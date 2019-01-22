FROM node:8.14.0-alpine

ARG VERSION=6.3.0

WORKDIR /app

RUN npm install -g firebase-tools@$VERSION

ENTRYPOINT [ "firebase" ]