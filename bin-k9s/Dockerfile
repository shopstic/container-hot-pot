FROM shopstic/curl-tar-unzip:1.0.1 as k9s

ARG PACKAGE_VERSION

RUN \
  curl -Lo - https://github.com/derailed/k9s/releases/download/v${PACKAGE_VERSION}/k9s_v${PACKAGE_VERSION}_Linux_x86_64.tar.gz | tar -xz -C /usr/bin/ && \
  chmod +x /usr/bin/k9s

FROM scratch
COPY --from=k9s /usr/bin/k9s /usr/bin/k9s