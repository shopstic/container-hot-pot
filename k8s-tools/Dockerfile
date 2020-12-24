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
    jq \
    vim \
    zsh && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" && \
  apt-get install -y docker-ce-cli && \
  curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  apt-get install -y nodejs && \
  rm -rf /var/lib/apt/lists/*

ENV K8S_VERSION "1.19.6"
ENV K9S_VERSION "0.24.2"
ENV DUMB_INIT_VERSION "1.2.2"
ENV KREW_VERSION "0.4.0"
ENV HELM_VERSION "3.4.2"
ENV HELMFILE_VERSION "0.135.0"
ENV SOPS_VERSION "3.6.1"
ENV AWSCLI_VERSION "2.1.13"
ENV AWS_IAM_AUTHENTICATOR_VERSION "1.18.9"
ENV STERN_VERSION "1.11.0"
ENV KUBE_PS1_VERSION "0.7.0"
ENV YQ_VERSION "4.0.0"
ENV DENO_VERSION "1.6.1"
ENV TERRAFORM_VERSION "0.14.3"

RUN \
  wget -O /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x /usr/bin/kubectl

RUN \
  wget -O - https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz | tar -xz -C /usr/bin/ && \
  chmod +x /usr/bin/k9s

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 && \
  chmod +x /usr/bin/dumb-init

RUN \
  mkdir -p /tmp/helm && \
  wget -O - https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xz -C /tmp/helm --strip-components=1 && \
  mv /tmp/helm/helm /usr/bin/helm && \
  chmod +x /usr/bin/helm && \
  rm -Rf /tmp/helm

RUN \
  curl -Lo /usr/bin/helmfile https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 && \
  chmod +x /usr/bin/helmfile

RUN \
  wget -O sops.deb https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb && \
  apt-get install ./sops.deb && \
  rm -f ./sops.deb

RUN \
  helm plugin install https://github.com/futuresimple/helm-secrets

RUN \
  mkdir /root/awscli && \
  cd /root/awscli && \
  wget -O awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" && \
  unzip awscliv2.zip && \
  ./aws/install && \
  rm -Rf /root/awscli

RUN \
  curl -Lo /usr/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/${AWS_IAM_AUTHENTICATOR_VERSION}/2020-04-16/bin/linux/amd64/aws-iam-authenticator && \
  chmod +x /usr/bin/aws-iam-authenticator

RUN \
  curl -Lo /usr/bin/stern https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 && \
  chmod +x /usr/bin/stern

RUN \
  wget -O /root/kube-ps1.sh https://raw.githubusercontent.com/jonmosco/kube-ps1/v${KUBE_PS1_VERSION}/kube-ps1.sh

RUN \
  curl -Lo /usr/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 && \
  chmod +x /usr/bin/yq

RUN \
  set -x; cd "$(mktemp -d)" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew.{tar.gz,yaml}" && \
  tar zxvf krew.tar.gz && \
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" && \
  "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz && \
  "$KREW" update && \
  export PATH="/root/.krew/bin:$PATH" && \
  kubectl krew install ctx && \
  kubectl krew install ns

RUN \
  mkdir /tmp/terraform && \
  cd /tmp/terraform && \
  wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform.zip && \
  mv terraform /usr/bin/terraform && \
  chmod +x /usr/bin/terraform && \
  rm -Rf /tmp/terraform

VOLUME /ssh
VOLUME /iac
WORKDIR /iac

ADD ./.zshrc /root/.zshrc
ADD ./entrypoint.sh /usr/bin/entrypoint.sh

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV TERM=xterm-256color

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
