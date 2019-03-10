FROM node:10.15-slim
WORKDIR /app
COPY package.json /app
COPY . /app
RUN npm install
CMD node server.js
EXPOSE 3000

