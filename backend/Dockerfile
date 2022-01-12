FROM node:17-alpine as base

WORKDIR /home/app

COPY package*.json ./

RUN npm i

COPY . .

FROM base as prisma

RUN npx prisma generate

FROM prisma as prod

RUN npm run build

EXPOSE 3000

CMD ["npm", "run", "start:prod"]