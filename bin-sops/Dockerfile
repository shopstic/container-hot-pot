FROM shopstic/curl-tar-unzip:1.0.1 as sops

ARG PACKAGE_VERSION

RUN \
  curl -Lo /usr/bin/sops https://github.com/mozilla/sops/releases/download/v${PACKAGE_VERSION}/sops-v${PACKAGE_VERSION}.linux && \
  chmod +x /usr/bin/sops

FROM scratch
COPY --from=sops /usr/bin/sops /usr/bin/sops