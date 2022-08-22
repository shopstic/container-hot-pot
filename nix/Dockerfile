FROM public.ecr.aws/lts/ubuntu:22.04_stable@sha256:00dab66161cbfde10804978655472bfb7764257af53ed4742b24081615b783c4 as installer

RUN \
  apt-get update \
  && apt-get install -y curl xz-utils

ARG NIX_VERSION=2.10.3
RUN \
  mkdir /installer && \
  curl -Lo - https://nixos.org/releases/nix/nix-${NIX_VERSION}/nix-${NIX_VERSION}-$(uname -m)-linux.tar.xz | tar -xJ -C /installer/ --strip-components=1

FROM public.ecr.aws/lts/ubuntu:22.04_stable@sha256:00dab66161cbfde10804978655472bfb7764257af53ed4742b24081615b783c4

RUN \
  apt-get update \
  && apt-get install -y ca-certificates git sudo

RUN \
  groupadd --gid 1001 runner && \
  useradd --home-dir /home/runner --create-home --uid 1001 \
  --gid 1001 --shell /bin/bash --skel /dev/null runner && \
  echo "runner  ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/runner

RUN \
  mkdir /nix \
  && chown runner:runner /nix

COPY --from=installer /installer /installer

RUN \
  su -c 'sh /installer/install' runner \
  && rm -Rf /installer

USER runner

ENV \
  PATH=/home/runner/.nix-profile/bin:$PATH \
  GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
  NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

COPY .gitconfig /home/runner/.gitconfig
  
ADD ./nix.conf /etc/nix/nix.conf