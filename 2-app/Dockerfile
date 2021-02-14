FROM node

WORKDIR /usr/src/app

COPY . .

RUN npm install axios next react react-dom

RUN npm run build

ENTRYPOINT npm run start