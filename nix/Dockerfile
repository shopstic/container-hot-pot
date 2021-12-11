FROM docker.io/library/ubuntu:focal-20211006@sha256:626ffe58f6e7566e00254b638eb7e0f3b11d4da9675088f4781a50ae288f3322

RUN \
  groupadd --gid 1001 runner && \
  useradd --home-dir /home/runner --create-home --uid 1001 \
  --gid 1001 --shell /bin/bash --skel /dev/null runner

RUN \
  mkdir /nix \
  && chown runner:runner /nix

USER runner
ARG NIX_VERSION=2.4
RUN \
  cd $HOME \
  && wget https://nixos.org/releases/nix/nix-${NIX_VERSION}/nix-${NIX_VERSION}-$(uname -m)-linux.tar.xz \
  && tar xf nix-${NIX_VERSION}-$(uname -m)-linux.tar.xz \
  && sh nix-${NIX_VERSION}-$(uname -m)-linux/install \
  && rm -rf nix-${NIX_VERSION}-$(uname -m)-linux*

ENV \
  PATH=$HOME/.nix-profile/bin:$PATH \
  GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
  NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

ADD ./nix.conf /etc/nix/nix.conf