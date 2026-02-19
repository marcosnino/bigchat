#!/bin/bash
# Patch para corrigir roteamento de mensagens fromMe no container
# Substitui a busca de contato por msg.from para usar msg.to quando fromMe=true

CONTAINER="bigchat-backend"
FILE="/app/dist/services/WbotServices/wbotMessageListener-wwjs.js"

# Criar o novo bloco de código
docker exec $CONTAINER bash -c "cat > /tmp/patch.py << 'PYEOF'
import re

with open('$FILE', 'r') as f:
    content = f.read()

# Trecho antigo (a ser substituído)
old_code = '''        // ─── Obter contato ───────────────────────────────
        const msgContact = await getContactSafe(msg);
        if (!msgContact) {
            logger_1.logger.error(\`[WWJS] Impossível obter contato de \${msg.from}, ignorando\`);
            return;
        }
        // ─── Verificar/criar contato no banco ────────────
        let contact;
        let groupContact;
        if (isGroup) {
            const chat = await msg.getChat();
            groupContact = await verifyGroupContact(chat, companyId);
            contact = await verifyContact(msgContact, companyId);
        }
        else {
            contact = await verifyContact(msgContact, companyId);
        }'''

# Trecho novo
new_code = '''        // ─── Obter contato ───────────────────────────────
        // Para fromMe, buscar contato do DESTINATÁRIO (msg.to)
        let msgContact;
        if (msg.fromMe && !isGroup) {
            logger_1.logger.info(\`[WWJS | HANDLER] fromMe=true, buscando contato do destinatario: \${msg.to}\`);
            try {
                const chat = await msg.getChat();
                const chatContact = chat?.contact;
                if (chatContact?.id?._serialized) {
                    msgContact = chatContact;
                } else {
                    const toNumber = getContactNumber(msg.to);
                    msgContact = {
                        id: { _serialized: msg.to, user: toNumber, server: \"c.us\" },
                        pushname: msg?._data?.notifyName || toNumber,
                        name: msg?._data?.notifyName || toNumber,
                        number: toNumber,
                        isGroup: false,
                        isMyContact: false,
                        isUser: true,
                        isWAContact: true,
                        getProfilePicUrl: async () => \"\"
                    };
                }
            } catch (err) {
                const toNumber = getContactNumber(msg.to);
                msgContact = {
                    id: { _serialized: msg.to, user: toNumber, server: \"c.us\" },
                    pushname: toNumber,
                    name: toNumber,
                    number: toNumber,
                    isGroup: false,
                    isMyContact: false,
                    isUser: true,
                    isWAContact: true,
                    getProfilePicUrl: async () => \"\"
                };
            }
        } else {
            msgContact = await getContactSafe(msg);
        }
        if (!msgContact) {
            logger_1.logger.error(\`[WWJS] Impossível obter contato de \${msg.fromMe ? msg.to : msg.from}, ignorando\`);
            return;
        }
        // ─── Verificar/criar contato no banco ────────────
        let contact;
        let groupContact;
        if (isGroup) {
            const chat2 = await msg.getChat();
            groupContact = await verifyGroupContact(chat2, companyId);
            contact = await verifyContact(msgContact, companyId);
        }
        else {
            contact = await verifyContact(msgContact, companyId);
        }'''

if old_code in content:
    content = content.replace(old_code, new_code)
    with open('$FILE', 'w') as f:
        f.write(content)
    print('PATCH APPLIED SUCCESSFULLY')
else:
    print('ERROR: Old code pattern not found!')
    # Procurar parcialmente para debug
    if 'getContactSafe(msg)' in content:
        print('  -> getContactSafe(msg) found in file')
    if 'Obter contato' in content:
        print('  -> "Obter contato" comment found')
PYEOF
"

docker exec $CONTAINER python3 /tmp/patch.py 2>/dev/null || {
    echo "Python3 not available, using sed approach..."
    
    # Abordagem com sed - substituir apenas a linha crítica
    docker exec $CONTAINER sed -i '
/const msgContact = await getContactSafe(msg);/{
i\        let msgContact;\
        if (msg.fromMe && !isGroup) {\
            logger_1.logger.info(`[WWJS | HANDLER] fromMe=true, buscando contato do destinatario: ${msg.to}`);\
            try {\
                const chat = await msg.getChat();\
                const chatContact = chat?.contact;\
                if (chatContact?.id?._serialized) {\
                    msgContact = chatContact;\
                } else {\
                    const toNumber = getContactNumber(msg.to);\
                    msgContact = { id: { _serialized: msg.to, user: toNumber, server: "c.us" }, pushname: toNumber, name: toNumber, number: toNumber, isGroup: false, isMyContact: false, isUser: true, isWAContact: true, getProfilePicUrl: async () => "" };\
                }\
            } catch (err) {\
                const toNumber = getContactNumber(msg.to);\
                msgContact = { id: { _serialized: msg.to, user: toNumber, server: "c.us" }, pushname: toNumber, name: toNumber, number: toNumber, isGroup: false, isMyContact: false, isUser: true, isWAContact: true, getProfilePicUrl: async () => "" };\
            }\
        } else {\
            msgContact = await getContactSafe(msg);\
        }
d
}
' $FILE
    
    echo "Sed patch applied"
}

echo "Done!"
