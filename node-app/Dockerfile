FROM node:11.14.0-stretch

RUN \
  wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod +x /usr/local/bin/dumb-init

WORKDIR /app

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]