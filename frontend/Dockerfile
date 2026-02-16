FROM node:20-alpine AS builder

WORKDIR /app

# Instalar dependências de build
RUN apk add --no-cache python3 make g++ git

# Copiar manifests e instalar deps
COPY package*.json ./
RUN npm install --force

# Copiar código fonte
COPY . .

# Variáveis injetadas no build do React (REACT_APP_*)
ARG REACT_APP_BACKEND_URL=http://api.drogariasbigmaster.com.br
ARG REACT_APP_HOURS_CLOSE_TICKETS_AUTO=24
ENV REACT_APP_BACKEND_URL=${REACT_APP_BACKEND_URL}
ENV REACT_APP_HOURS_CLOSE_TICKETS_AUTO=${REACT_APP_HOURS_CLOSE_TICKETS_AUTO}

# Build React (react-scripts precisa de --openssl-legacy-provider no Node 20)
ENV NODE_OPTIONS=--openssl-legacy-provider
ENV GENERATE_SOURCEMAP=false

# Se existir build pré-compilado, usar; caso contrário, compilar
RUN if [ -d "build_precompiled" ] && [ -f "build_precompiled/index.html" ]; then \
      echo "Usando build pré-compilado..." && \
      rm -rf build && mv build_precompiled build; \
    else \
      echo "Compilando React..." && \
      npm run build; \
    fi

# ========== Produção ==========
FROM nginx:1.27-alpine

RUN apk add --no-cache curl

COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
