FROM summerwind/actions-runner-dind:v2.289.1-ubuntu-20.04-debf53c

USER root
RUN \
  mkdir /nix \
  && chown runner:runner /nix

USER runner
ARG NIX_VERSION=2.10.3
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