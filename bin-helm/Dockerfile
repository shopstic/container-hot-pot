FROM shopstic/curl-tar-unzip:1.0.1 as helm

ARG PACKAGE_VERSION

RUN \
  mkdir -p /tmp/helm && \
  curl -L "https://get.helm.sh/helm-v${PACKAGE_VERSION}-linux-amd64.tar.gz" | tar -xz -C /tmp/helm --strip-components=1 && \
  mv /tmp/helm/helm /usr/bin/helm && \
  chmod +x /usr/bin/helm && \
  rm -Rf /tmp/helm

FROM scratch
COPY --from=helm /usr/bin/helm /usr/bin/helm