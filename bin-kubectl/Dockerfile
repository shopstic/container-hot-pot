FROM shopstic/curl-tar-unzip:1.0.1 as kubectl

ARG PACKAGE_VERSION

RUN \
  curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${PACKAGE_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x /usr/bin/kubectl

FROM scratch
COPY --from=kubectl /usr/bin/kubectl /usr/bin/kubectl