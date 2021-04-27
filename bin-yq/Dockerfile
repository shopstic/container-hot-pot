FROM shopstic/curl-tar-unzip:1.0.1 as jq

ARG PACKAGE_VERSION

RUN \
  curl -Lo /usr/bin/yq https://github.com/mikefarah/yq/releases/download/v${PACKAGE_VERSION}/yq_linux_amd64 && \
  chmod +x /usr/bin/yq

FROM scratch
COPY --from=yq /usr/bin/yq /usr/bin/yq