FROM node:22-bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates tar gzip openssl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev --no-audit --no-fund && npm cache clean --force
COPY --chown=node:node . .
RUN mkdir -p /app/bk-data && chown -R node:node /app/bk-data

ENV NODE_ENV=production \
    PORT=8080 \
    BK_DATA_DIR=/app/bk-data \
    LINK_PORT=443 \
    LINK_TLS=true \
    FORCE_HTTPS=true

USER node
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=3 \
    CMD node -e "fetch('http://127.0.0.1:'+(process.env.PORT||8080)+'/knight',{redirect:'manual'}).then(r=>process.exit(r.status>=200&&r.status<400?0:1)).catch(()=>process.exit(1))"
CMD ["node", "index.js"]
