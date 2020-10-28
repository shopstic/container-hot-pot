# kubectl ------------------------------------------------------------------
FROM shopstic/curl-tar-unzip:1.0.1 as kubectl

ENV K8S_VERSION "1.19.3"

RUN \
  curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x /usr/bin/kubectl

# k9s ------------------------------------------------------------------
FROM shopstic/curl-tar-unzip:1.0.0 as k9s

ENV K9S_VERSION "0.22.1"

RUN \
  curl -Lo - https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz | tar -xz -C /usr/bin/ && \
  chmod +x /usr/bin/k9s

# kind ------------------------------------------------------------------
FROM shopstic/curl-tar-unzip:1.0.0 as kind

ENV KIND_VERSION "0.9.0"

RUN \
  curl -Lo /usr/bin/kind https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_VERSION}/kind-linux-amd64 && \
  chmod +x /usr/bin/kind

FROM docker:19.03.13-dind

# buildx ------------------------------------------------------------------
FROM shopstic/curl-tar-unzip:1.0.0 as buildx

ENV BUILDX_VERSION "0.4.2"

RUN \
  mkdir -p ~/.docker/cli-plugins && \
  curl -Lo ~/.docker/cli-plugins/docker-buildx https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-amd64 && \
  chmod +x ~/.docker/cli-plugins/docker-buildx

# aws-cli ------------------------------------------------------------------
FROM shopstic/curl-tar-unzip:1.0.0 as aws-cli

ENV AWSCLI_VERSION "2.0.52"

RUN \
  mkdir /root/awscli && \
  cd /root/awscli && \
  curl -Lo awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" && \
  unzip awscliv2.zip && \
  ./aws/install && \
  rm -Rf /root/awscli

FROM docker:19.03.13-dind

ENV LANG=C.UTF-8

# Here we install GNU libc (aka glibc) and set C.UTF-8 locale as default.
RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.32-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    echo \
        "-----BEGIN PUBLIC KEY-----\
        MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApZ2u1KJKUu/fW4A25y9m\
        y70AGEa/J3Wi5ibNVGNn1gT1r0VfgeWd0pUybS4UmcHdiNzxJPgoWQhV2SSW1JYu\
        tOqKZF5QSN6X937PTUpNBjUvLtTQ1ve1fp39uf/lEXPpFpOPL88LKnDBgbh7wkCp\
        m2KzLVGChf83MS0ShL6G9EQIAUxLm99VpgRjwqTQ/KfzGtpke1wqws4au0Ab4qPY\
        KXvMLSPLUp7cfulWvhmZSegr5AdhNw5KNizPqCJT8ZrGvgHypXyiFvvAH5YRtSsc\
        Zvo9GI2e2MaZyo9/lvb+LbLEJZKEQckqRj4P26gmASrZEPStwc+yqy1ShHLA0j6m\
        1QIDAQAB\
        -----END PUBLIC KEY-----" | sed 's/   */\n/g' > "/etc/apk/keys/sgerrand.rsa.pub" && \
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

RUN \
  set -eux; \
  apk add --no-cache \
  curl bash git jq rsync pv lz4 gnupg

RUN \
  ln -s /usr/local/aws-cli/v2/current/bin/aws /usr/local/bin/aws

ENV TINI_VERSION "v0.19.0"
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN \
  chmod +x /bin/tini && \
  mv /bin/bash /bin/bash.real
COPY --from=shopstic/tinish:1.0.0 /bin/tinish /bin/bash

COPY --from=kubectl /usr/bin/kubectl /usr/bin/kubectl
COPY --from=k9s /usr/bin/k9s /usr/bin/k9s
COPY --from=buildx /root/.docker/cli-plugins /root/.docker/cli-plugins
COPY --from=kind /usr/bin/kind /usr/bin/kind
COPY --from=aws-cli /usr/local/aws-cli /usr/local/aws-cli

ENTRYPOINT ["/bin/bash"]
