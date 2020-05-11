FROM node
WORKDIR /home/node/app
COPY . .
CMD yarn serve