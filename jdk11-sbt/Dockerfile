FROM openjdk:11.0.7-slim as stage0

RUN \
  apt-get update && \
  apt-get install -y curl unzip

ARG PACKAGE_VERSION

RUN \
  mkdir /sbt && \
  cd /sbt && \
  curl -Lo sbt.zip https://github.com/sbt/sbt/releases/download/v${PACKAGE_VERSION}/sbt-${PACKAGE_VERSION}.zip && \
  unzip sbt.zip && rm -Rf sbt.zip && rm -Rf sbt/lib && mv /sbt/sbt/* /sbt/ && rm -Rf sbt && \
  chmod a+x /sbt/bin/sbt

RUN \
  cd /sbt/bin && \
  curl -Lo sbt-client.gz https://github.com/cb372/sbt-client/releases/download/v0.1.2/sbt-client-v0.1.2-x86_64-unknown-linux-gnu.gz && \
  gunzip sbt-client.gz && \
  rm -f sbt-client.gz && \
  chmod +x sbt-client

ENV PATH="$PATH:/sbt/bin"

RUN sbt sbtVersion

RUN \
  curl -Lko fdb-clients.deb https://www.foundationdb.org/downloads/6.2.20/ubuntu/installers/foundationdb-clients_6.2.20-1_amd64.deb && \
  apt-get install ./fdb-clients.deb && \
  rm -f fdb-clients.deb

ENTRYPOINT []

CMD []
