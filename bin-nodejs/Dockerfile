FROM ubuntu:20.04 as bin-nodejs-stage

ARG PACKAGE_VERSION

RUN \
  apt-get update && \
  apt-get install -y curl xz-utils

RUN \
  mkdir /nodejs && \
  curl -Lo - https://nodejs.org/dist/v${PACKAGE_VERSION}/node-v${PACKAGE_VERSION}-linux-x64.tar.xz | tar -xJ -C /nodejs --strip-components=1

FROM scratch as bin-nodejs
COPY --from=bin-nodejs-stage /nodejs /usr
