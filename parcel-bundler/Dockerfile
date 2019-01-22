FROM node:8.14.0-alpine

ARG VERSION=1.11.0

WORKDIR /app

RUN npm install -g parcel-bundler@$VERSION

ENTRYPOINT [ "parcel" ]