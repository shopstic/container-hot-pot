FROM shopstic/curl-tar-unzip:1.0.1 as buildkit

ARG PACKAGE_VERSION

RUN \
  mkdir /buildkit && \
  curl -Lo - https://github.com/moby/buildkit/releases/download/v0.8.2/buildkit-v0.8.2.linux-amd64.tar.gz | tar -xz -C /buildkit/ --strip-components=1 && \
  chmod +x /buildkit/* && \
  ls -la /buildkit/*

FROM scratch
COPY --from=buildkit /buildkit/buildctl /usr/bin/buildctl