FROM golang:1.11.4-stretch

ARG SHOPSTIC_GITHUB_TOKEN

RUN \
  git clone --depth 1 "https://${SHOPSTIC_GITHUB_TOKEN}@github.com/shopstic/docker-registry-semver-bump" && \
  cd docker-registry-semver-bump && \
  ./cli install

FROM golang:1.11.4-stretch
COPY --from=0 /go/bin/docker-registry-semver-bump /go/bin/docker-registry-semver-bump