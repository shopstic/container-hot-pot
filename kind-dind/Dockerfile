FROM docker:19.03.13-dind

RUN \
  set -eux; \
  apk add --no-cache \
  curl bash git jq rsync

ENV K9S_VERSION "0.22.1"
ENV K9S_VERSION "0.22.1"
ENV K8S_VERSION "1.19.2"
ENV KIND_VERSION "0.9.0"
ENV DUMB_INIT_VERSION "1.2.2"
ENV BUILDX_VERSION "0.4.2"

RUN \
  mkdir -p ~/.docker/cli-plugins && \
  wget -O ~/.docker/cli-plugins/docker-buildx https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-amd64 && \
  chmod +x ~/.docker/cli-plugins/docker-buildx

RUN \
  wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 && \
  chmod +x /usr/bin/dumb-init

RUN \
  wget -O /usr/bin/kind https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_VERSION}/kind-linux-amd64 && \
  chmod +x /usr/bin/kind

RUN \
  wget -O /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x /usr/bin/kubectl

RUN \
  wget -O - https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz | tar -xz -C /usr/bin/ && \
  chmod +x /usr/bin/k9s
