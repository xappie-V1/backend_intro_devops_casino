# ---------- Etapa builder ----------
FROM node:20-alpine AS builder
WORKDIR /app
# Copiar dependencias
COPY package*.json ./
# Instalar dependencias
RUN npm ci --omit=dev
# Copiar código
COPY src ./src

# ---------- Etapa runtime ----------
FROM node:20-alpine AS runtime
WORKDIR /app
# Copiar aplicación
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src ./src
COPY --from=builder /app/package.json ./package.json
# Dar permisos al usuario node
RUN chown -R node:node /app
# Ejecutar como usuario no privilegiado
USER node
EXPOSE 3000
CMD ["node", "src/server.js"]