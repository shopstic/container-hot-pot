FROM golang:1.11.4-stretch

ARG SHOPSTIC_GITHUB_TOKEN

RUN \
  git clone --depth 1 "https://${SHOPSTIC_GITHUB_TOKEN}@github.com/shopstic/docker-registry-semver-bump" && \
  cd docker-registry-semver-bump && \
  ./cli install

FROM golang:1.11.4-stretch
COPY --from=0 /go/bin/docker-registry-semver-bump /go/bin/docker-registry-semver-bump
ENV DOCKER_CLIENT_VERSION="17.03.0-ce"
RUN \
  curl -L -o /tmp/docker-$DOCKER_CLIENT_VERSION.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLIENT_VERSION.tgz && \
  tar -xz -C /tmp -f /tmp/docker-$DOCKER_CLIENT_VERSION.tgz && \
  mv /tmp/docker/* /usr/bin && \
  rm -Rf /tmp/docker-$DOCKER_CLIENT_VERSION.tgz && \
  rm -Rf /tmp/docker