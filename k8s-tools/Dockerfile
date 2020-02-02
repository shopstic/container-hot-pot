FROM ubuntu:18.04

RUN \
  apt-get update && \
  apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    wget \
    apt-transport-https \
    gnupg2 \
    nano \
    sshpass \
    openssh-client \
    openssh-server \
    git \
    unzip \
    pv \
    rsync \
    jq && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" && \
  apt-get update && \
  apt-get install -y docker-ce-cli

RUN \
  wget -O /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kubectl && \
  chmod +x /usr/bin/kubectl

RUN \
  wget -O - https://github.com/derailed/k9s/releases/download/v0.20.5/k9s_Linux_x86_64.tar.gz | tar -xz -C /usr/bin/ && \
  chmod +x /usr/bin/k9s

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod +x /usr/bin/dumb-init

RUN \
  set -x; cd "$(mktemp -d)" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" && \
  tar zxvf krew.tar.gz && \
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" && \
  "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz && \
  "$KREW" update && \
  echo 'PATH="/root/.krew/bin:$PATH"' >> /root/.bashrc

ENV PATH="/root/.krew/bin:$PATH"

RUN \
  kubectl krew install ctx && \
  kubectl krew install ns

RUN \
  mkdir -p /tmp/helm && \
  wget -O - https://get.helm.sh/helm-v3.2.2-linux-amd64.tar.gz | tar -xz -C /tmp/helm --strip-components=1 && \
  mv /tmp/helm/helm /usr/bin/helm && \
  chmod +x /usr/bin/helm && \
  rm -Rf /tmp/helm

RUN \
  curl -Lo /usr/bin/helmfile https://github.com/roboll/helmfile/releases/download/v0.118.6/helmfile_linux_amd64 && \
  chmod +x /usr/bin/helmfile

RUN \
  wget -O sops.deb https://github.com/mozilla/sops/releases/download/v3.5.0/sops_3.5.0_amd64.deb && \
  apt-get install ./sops.deb && \
  rm -f ./sops.deb

RUN \
  helm plugin install https://github.com/futuresimple/helm-secrets

RUN \
  mkdir /root/awscli && \
  cd /root/awscli && \
  wget -O awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" && \
  unzip awscliv2.zip && \
  ./aws/install && \
  rm -Rf /root/awscli

RUN \
  curl -Lo /usr/bin/stern https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 && \
  chmod +x /usr/bin/stern

RUN \
  wget -O /root/kube-ps1.sh https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh && \
  echo "KUBE_PS1_CTX_COLOR=white" >> /root/.bashrc && \
  echo "KUBE_PS1_SYMBOL_COLOR=cyan" >> /root/.bashrc && \
  echo "source /root/kube-ps1.sh" >> /root/.bashrc && \
  echo "PS1='[\\u@\\h \\W \$(kube_ps1)]\\$ '" >> /root/.bashrc

RUN \
  mkdir /tmp/terraform && \
  cd /tmp/terraform && \
  wget -O terraform.zip https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip && \
  unzip terraform.zip && \
  mv terraform /usr/bin/terraform && \
  chmod +x /usr/bin/terraform && \
  rm -Rf /tmp/terraform

RUN \
  curl -Lo /usr/bin/kops https://github.com/kubernetes/kops/releases/download/v1.17.0/kops-linux-amd64 && \
  chmod +x /usr/bin/kops

RUN \
  curl -Lo /usr/bin/yq https://github.com/mikefarah/yq/releases/download/3.3.0/yq_linux_amd64 && \
  chmod +x /usr/bin/yq

VOLUME /ssh
VOLUME /iac
WORKDIR /iac

RUN \
  echo 'PATH="/iac:$PATH"' >> /root/.bashrc

ADD ./entrypoint.sh /usr/bin/entrypoint.sh

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV TERM=xterm-256color

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]