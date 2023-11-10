FROM node:latest

RUN apt-get -y update 

RUN apt-get -y upgrade

WORKDIR /front

COPY . .

RUN npm install

RUN node -v

RUN npm -v

RUN npm run build

EXPOSE 5173

EXPOSE 80

EXPOSE 8080

CMD ["npm", "run", "dev"]