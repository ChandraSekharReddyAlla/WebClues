FROM node:alphine
RUN mkdir -p /app
WORKDIR /app
COPY package*.json ./
RUN npm install
EXPOSE 3000
CMD ["node", "server.js"]
