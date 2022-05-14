FROM node:17-alpine

WORKDIR /home/app

COPY rollup.config.js ./

COPY package*.json ./

RUN npm install

COPY ./src ./src

COPY ./public ./public

ARG API

ENV API $API 

RUN touch ./.env

RUN printenv > ./.env

RUN npm run build

ENV HOST=0.0.0.0


CMD [ "npm", "start" ]