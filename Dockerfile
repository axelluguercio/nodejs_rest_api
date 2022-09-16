FROM node:16-slim

WORKDIR /usr/src/app

# Copy dependencies
COPY ./package*.json ./

RUN npm install

COPY . .

USER node

EXPOSE 4000

CMD [ "npm", "start" ]