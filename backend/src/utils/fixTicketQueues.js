/**
 * Script para corrigir tickets sem fila
 * Associa tickets existentes à fila padrão do WhatsApp
 */

const { Ticket, Whatsapp, WhatsappQueue } = require('../models');

const fixTicketQueues = async () => {
  console.log('🔧 Iniciando correção de filas dos tickets...');
  
  try {
    // Buscar tickets sem fila
    const ticketsWithoutQueue = await Ticket.findAll({
      where: {
        queueId: null,
        companyId: 1
      },
      include: ['whatsapp']
    });
    
    console.log(`📝 Encontrados ${ticketsWithoutQueue.length} tickets sem fila`);
    
    for (const ticket of ticketsWithoutQueue) {
      if (ticket.whatsappId) {
        // Buscar primeira fila associada ao WhatsApp
        const whatsappQueue = await WhatsappQueue.findOne({
          where: { whatsappId: ticket.whatsappId },
          order: [['queueId', 'ASC']]
        });
        
        if (whatsappQueue) {
          await ticket.update({ queueId: whatsappQueue.queueId });
          console.log(`✅ Ticket ${ticket.id} atualizado com fila ${whatsappQueue.queueId}`);
        } else {
          console.log(`⚠️ Nenhuma fila encontrada para WhatsApp ${ticket.whatsappId}`);
        }
      }
    }
    
    console.log('✨ Correção concluída!');
  } catch (err) {
    console.error('❌ Erro na correção:', err);
  }
};

module.exports = fixTicketQueues;

// Se executado diretamente
if (require.main === module) {
  fixTicketQueues().then(() => process.exit(0));
}