FROM openjdk:11.0.9-slim as stage0

RUN \
  apt-get update && \
  apt-get install -y curl unzip git && \
  rm -rf /var/lib/apt/lists/*

ARG PACKAGE_VERSION

RUN \
  mkdir /sbt && \
  cd /sbt && \
  curl -Lo sbt.zip https://github.com/sbt/sbt/releases/download/v${PACKAGE_VERSION}/sbt-${PACKAGE_VERSION}.zip && \
  unzip sbt.zip && rm -Rf sbt.zip && rm -Rf sbt/lib && mv /sbt/sbt/* /sbt/ && rm -Rf sbt && \
  chmod a+x /sbt/bin/sbt

ENV PATH="$PATH:/sbt/bin"

RUN \
  mkdir ~/temp && \
  cd ~/temp && \
  sbt sbtVersion && \
  rm -Rf ~/temp

ENV FDB_VERSION "6.2.27"

RUN \
  curl -Lko fdb-clients.deb https://www.foundationdb.org/downloads/${FDB_VERSION}/ubuntu/installers/foundationdb-clients_${FDB_VERSION}-1_amd64.deb && \
  apt-get install ./fdb-clients.deb && \
  rm -f fdb-clients.deb

ENTRYPOINT []

CMD []
