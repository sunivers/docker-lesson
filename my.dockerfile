FROM node:latest AS build
WORKDIR /home/node/app
COPY package.json ./package.json
COPY package-lock.json ./package-lock.json
RUN npm install

FROM node:latest
WORKDIR /home/node/app
COPY --from=build /home/node/app .
COPY . .
CMD yarn serve
EXPOSE 8080