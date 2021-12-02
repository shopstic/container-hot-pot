ARG PACKAGE_VERSION

FROM summerwind/actions-runner-dind:${PACKAGE_VERSION}

USER root

RUN \
  groupadd -g 30000 --system nixbld && \
  for i in $(seq 1 32); do \
    useradd \
      --home-dir /var/empty \
      --gid 30000 \
      --groups nixbld \
      --no-user-group \
      --system \
      --shell /usr/sbin/nologin \
      --uid $((30000 + i)) \
      --password "!" \
      nixbld$i; done && \
  mkdir -m 0755 /etc/nix

# Download Nix and install it into the system.
ARG NIX_VERSION=2.4
RUN wget https://nixos.org/releases/nix/nix-${NIX_VERSION}/nix-${NIX_VERSION}-$(uname -m)-linux.tar.xz \
  && tar xf nix-${NIX_VERSION}-$(uname -m)-linux.tar.xz && \
  mkdir -m 0755 /nix && USER=root sh nix-${NIX_VERSION}-$(uname -m)-linux/install \
  && ln -s /nix/var/nix/profiles/default/etc/profile.d/nix.sh /etc/profile.d/ \
  && rm -r /nix-${NIX_VERSION}-$(uname -m)-linux* \
  && rm -rf /var/cache/apk/* \
  && /nix/var/nix/profiles/default/bin/nix-collect-garbage --delete-old \
  && /nix/var/nix/profiles/default/bin/nix-store --optimise \
  && /nix/var/nix/profiles/default/bin/nix-store --verify --check-contents

ADD ./nix.conf /etc/nix/nix.conf

ONBUILD ENV \
  ENV=/etc/profile \
  USER=root \
  PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:$PATH \
  GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
  NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

ENV \
  ENV=/etc/profile \
  USER=root \
  PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:$PATH \
  GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
  NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
  NIX_PATH=/nix/var/nix/profiles/per-user/root/channels

USER runner