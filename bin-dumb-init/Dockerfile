FROM shopstic/curl-tar-unzip:1.0.1 as dumb-init

ARG PACKAGE_VERSION

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${PACKAGE_VERSION}/dumb-init_${PACKAGE_VERSION}_amd64 && \
  chmod +x /usr/bin/dumb-init

FROM scratch
COPY --from=dumb-init /usr/bin/dumb-init /usr/bin/dumb-init