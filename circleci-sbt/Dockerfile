FROM openjdk:11.0.1-jre-slim

RUN \
  apt-get update -y && \
  apt-get install -y git python curl unzip && apt-get clean

RUN \
  curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
  unzip awscli-bundle.zip && \
  ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
  rm -Rf awscli-bundle.zip awscli-bundle && \
  aws --version

ENV PATH="$PATH:/sbt/bin"
ENV SBT_VERSION="1.2.8"

RUN \
  curl -Lo /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
  chmod +x /usr/bin/jq

RUN \
  mkdir /sbt && cd /sbt && \
  curl -Lo sbt.zip https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.zip && \
  unzip sbt.zip && rm -Rf sbt.zip && rm -Rf sbt/lib && mv /sbt/sbt/* /sbt/ && rm -Rf sbt && \
  chmod a+x /sbt/bin/sbt && \
  sbt sbtVersion
