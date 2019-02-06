FROM node:11.8.0-alpine

RUN apk add --update dumb-init && rm -rf /var/cache/apk/*

WORKDIR /app

ENTRYPOINT ["/usr/bin/dumb-init", "--"]