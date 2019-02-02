FROM node:11.6.0-alpine

ARG VERSION=3.25.3

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
  && pip install virtualenv \
  && rm -rf /var/cache/apk/*

RUN mkdir /app && \
    npm install --unsafe -g polyfill-service@${VERSION}

FROM node:11.6.0-alpine
RUN apk add --update dumb-init && rm -rf /var/cache/apk/*
COPY --from=0 /usr/local/lib/node_modules/polyfill-service /usr/local/lib/node_modules/polyfill-service
ENV NODE_ENV=production
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/local/lib/node_modules/polyfill-service/bin/polyfill-service"]  