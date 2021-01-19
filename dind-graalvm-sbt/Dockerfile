FROM ubuntu:18.04

ENV BAT_VERSION "0.17.1"
ENV EXA_VERSION "0.9.0"
ENV RIPGREP_VERSION "12.1.1"

RUN apt-get update

RUN \
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
  zsh

RUN \
  curl -Lo graalvm-ce-java11-linux-amd64-20.1.0.tar.gz "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.1.0/graalvm-ce-java11-linux-amd64-20.1.0.tar.gz" && \
  tar -zxvf graalvm-ce-java11-linux-amd64-20.1.0.tar.gz

ENV PATH="$PATH:/graalvm-ce-java11-20.1.0/bin"

ENV SBT_VERSION "1.3.12"

RUN \
  mkdir /sbt && \
  cd /sbt && \
  curl -Lo sbt.zip https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.zip && \
  unzip sbt.zip && rm -Rf sbt.zip && rm -Rf sbt/lib && mv /sbt/sbt/* /sbt/ && rm -Rf sbt && \
  chmod a+x /sbt/bin/sbt

ENV PATH="$PATH:/sbt/bin"

RUN sbt sbtVersion

RUN \
  apt-get install -y build-essential libz-dev zlib1g-dev && \
  gu install native-image

RUN \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" && \
  apt-get install -y docker-ce-cli

ENTRYPOINT [ "zsh" ]
