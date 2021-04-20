FROM shopstic/curl-tar-unzip:1.0.1 as bin-docker

ARG PACKAGE_VERSION

RUN \
  mkdir /temp && \
  cd /temp && \
  curl -Lo - https://download.docker.com/linux/static/stable/x86_64/docker-${PACKAGE_VERSION}.tgz | tar -xz -C /temp/ --strip-components=1 && \
  mv /temp/docker /usr/bin/docker && \
  chmod +x /usr/bin/docker && \
  rm -Rf /temp

FROM scratch
COPY --from=bin-docker /usr/bin/docker /usr/bin/docker