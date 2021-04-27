FROM shopstic/curl-tar-unzip:1.0.1 as yq

ARG PACKAGE_VERSION

RUN \
  curl -Lo /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-${PACKAGE_VERSION}/jq-linux64 && \
  chmod +x /usr/bin/jq

FROM scratch
COPY --from=yq /usr/bin/jq /usr/bin/jq