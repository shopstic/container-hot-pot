FROM docker.io/library/alpine:3.15.0@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300

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