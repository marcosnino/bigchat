FROM node:20-alpine

WORKDIR /app

# Dependências de sistema (Puppeteer/Chromium + ferramentas de build para módulos nativos)
RUN apk add --no-cache \
    tini curl \
    chromium nss freetype harfbuzz ca-certificates ttf-freefont \
    python3 make g++ git

# Puppeteer: usar Chromium do Alpine
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV NODE_ENV=production

# Instalar dependências (incluindo devDeps temporariamente para módulos nativos)
COPY package*.json ./
RUN npm install --force && npm cache clean --force

# Copiar dist já compilado e demais arquivos necessários
COPY dist/ ./dist/
COPY .sequelizerc ./
COPY public/ ./public/

# Criar .env vazio — as variáveis vêm do docker-compose (env_file)
# mas o dotenv.config() precisa do arquivo existente para não falhar
RUN touch .env

# Criar diretórios necessários (inclui .sessions para whatsapp-web.js)
RUN mkdir -p logs public .sessions && chmod 777 .sessions

EXPOSE 4000

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:4000/health || exit 1

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/server.js"]
