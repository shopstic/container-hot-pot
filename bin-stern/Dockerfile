FROM shopstic/curl-tar-unzip:1.0.1 as stern

ARG PACKAGE_VERSION

RUN \
  curl -Lo - https://github.com/stern/stern/releases/download/v${PACKAGE_VERSION}/stern_${PACKAGE_VERSION}_linux_amd64.tar.gz | tar -xz -C /usr/bin/ && \
  mv /usr/bin/stern_* /usr/bin/stern && \
  chmod +x /usr/bin/stern

FROM scratch
COPY --from=stern /usr/bin/stern /usr/bin/stern