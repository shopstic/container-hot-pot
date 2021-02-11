FROM verdaccio/verdaccio@sha256:6b053917af571e4a4ce3cc12eb2ffb6fd7a4e1abfb6027e5eb5562e80548f3f9

USER root

ENV NODE_ENV=production

## perhaps all of this is not fully required
RUN apk --no-cache add openssl ca-certificates wget && \
  apk --no-cache add g++ gcc libgcc libstdc++ linux-headers make python && \
  wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
  apk add glibc-2.25-r0.apk

RUN npm i && npm install verdaccio-aws-s3-storage
USER verdaccio