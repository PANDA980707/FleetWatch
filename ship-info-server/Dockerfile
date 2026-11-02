FROM node:22-alpine
WORKDIR /app
COPY package.json ./
RUN npm install --omit=dev
COPY server.js community.js ./
COPY public ./public
ENV PORT=3000
ENV DB_PATH=/data/data.db
RUN mkdir -p /data && chown node /data
EXPOSE 3000
USER node
CMD ["node","server.js"]
