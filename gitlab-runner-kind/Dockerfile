FROM gitlab/gitlab-runner:v12.9.0

RUN \
  wget -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/3.3.0/yq_linux_amd64 && \
  chmod +x /usr/local/bin/yq

RUN \
  wget -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.17.4/bin/linux/amd64/kubectl && \
  chmod +x /usr/local/bin/kubectl

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod +x /usr/bin/dumb-init