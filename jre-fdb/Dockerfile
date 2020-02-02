FROM openjdk:11.0.6-jre-slim

RUN \
  apt-get update && \
  apt-get install -y curl

RUN \
  curl -Lo fdb-clients.deb https://www.foundationdb.org/downloads/6.2.19/ubuntu/installers/foundationdb-clients_6.2.19-1_amd64.deb && \
  apt-get install ./fdb-clients.deb && \
  rm -f fdb-clients.deb
