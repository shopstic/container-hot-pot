FROM docker:19.03.8-dind

RUN set -eux; \
	apk add --no-cache \
  curl bash git jq rsync

RUN \
  wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod +x /usr/bin/dumb-init
RUN \
  wget -O /usr/local/bin/kind https://github.com/kubernetes-sigs/kind/releases/download/v0.8.1/kind-linux-amd64 && \
  chmod +x /usr/local/bin/kind

RUN \
  wget -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kubectl && \
  chmod +x /usr/local/bin/kubectl

RUN \
  wget -O - https://github.com/derailed/k9s/releases/download/v0.20.5/k9s_Linux_x86_64.tar.gz | tar -xz -C /usr/local/bin/ && \
  chmod +x /usr/local/bin/k9s

RUN \
  mkdir -p /tmp/helm && \
  wget -O - https://get.helm.sh/helm-v3.2.2-linux-amd64.tar.gz | tar -xz -C /tmp/helm --strip-components=1 && \
  mv /tmp/helm/helm /usr/local/bin/helm && \
  chmod +x /usr/local/bin/helm && \
  rm -Rf /tmp/helm

RUN \
  curl -Lo /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/v0.118.6/helmfile_linux_amd64 && \
  chmod +x /usr/local/bin/helmfile

RUN \
  wget -O /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/v3.5.0/sops-v3.5.0.linux && \
  chmod +x /usr/local/bin/sops

RUN \
  helm plugin install https://github.com/futuresimple/helm-secrets

RUN \
  set -x; cd "$(mktemp -d)" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" && \
  tar zxvf krew.tar.gz && \
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" && \
  "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz && \
  "$KREW" update && \
  echo 'PATH="/root/.krew/bin:$PATH"' >> /root/.zshrc

ENV PATH="/root/.krew/bin:$PATH"

RUN \
  kubectl krew install ctx && \
  kubectl krew install konfig

RUN \
  wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 && \
  chmod +x /usr/local/bin/gitlab-runner

WORKDIR /app