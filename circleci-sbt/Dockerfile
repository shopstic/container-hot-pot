FROM circleci/openjdk:8u212-jdk-stretch

ENV PATH="$PATH:/sbt/bin"
ENV SBT_VERSION="1.2.8"

RUN \
  sudo mkdir /sbt && \
  sudo chown circleci:circleci /sbt && \
  cd /sbt && \
  curl -Lo sbt.zip https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.zip && \
  unzip sbt.zip && rm -Rf sbt.zip && rm -Rf sbt/lib && mv /sbt/sbt/* /sbt/ && rm -Rf sbt && \
  chmod a+x /sbt/bin/sbt && \
  sbt sbtVersion
