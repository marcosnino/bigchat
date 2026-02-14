FROM nginx:1.27-alpine

RUN apk add --no-cache curl bash

# Copia config inicial (sem SSL) para bootstrap
COPY nginx-initial.conf /etc/nginx/nginx-initial.conf
# Copia config SSL de produção
COPY nginx.conf /etc/nginx/nginx-production.conf

# Script de entrypoint que seleciona config baseado na existência dos certs
RUN printf '#!/bin/sh\n\
if [ -f /etc/letsencrypt/live/desk.drogariasbigmaster.com.br/fullchain.pem ] && \
   [ -f /etc/letsencrypt/live/api.drogariasbigmaster.com.br/fullchain.pem ]; then\n\
  echo "SSL certs found, using production config"\n\
  cp /etc/nginx/nginx-production.conf /etc/nginx/nginx.conf\n\
else\n\
  echo "SSL certs NOT found, using initial config (no SSL)"\n\
  cp /etc/nginx/nginx-initial.conf /etc/nginx/nginx.conf\n\
fi\n\
exec nginx -g "daemon off;"\n' > /docker-entrypoint-custom.sh && chmod +x /docker-entrypoint-custom.sh

EXPOSE 80 443

CMD ["/docker-entrypoint-custom.sh"]
