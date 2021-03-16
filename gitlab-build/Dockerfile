FROM ubuntu:20.04

RUN \
  apt-get update && \
  apt-get install -y curl

ENV BUILDKIT_VERSION=0.8.2
RUN \
  curl -L https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz | tar -xzf - -C /usr/bin/ --strip-components=1