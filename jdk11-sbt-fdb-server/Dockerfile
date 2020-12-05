FROM shopstic/jdk11-sbt:1.4.4

ENV FDB_VERSION "6.2.27"

RUN \
  curl -Lko fdb-server.deb https://www.foundationdb.org/downloads/${FDB_VERSION}/ubuntu/installers/foundationdb-server_${FDB_VERSION}-1_amd64.deb && \
  apt-get install ./fdb-server.deb -y && \
  rm -f fdb-server.deb
