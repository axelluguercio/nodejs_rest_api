FROM node:16-slim

WORKDIR /usr/src/app

# Copy dependencies file lock json
COPY ./package*.json ./

# install dependencies
RUN npm install

COPY . .

USER node

EXPOSE 4000

# start app for production
CMD [ "npm", "start" ]