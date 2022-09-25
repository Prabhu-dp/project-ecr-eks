FROM node:latest

WORKDIR /app

COPY . /app

RUN npm install

EXPOSE 9000

CMD ["node","server.js"]

