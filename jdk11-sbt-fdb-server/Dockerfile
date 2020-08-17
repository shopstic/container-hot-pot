FROM shopstic/jdk11-sbt:1.3.12

RUN \
  curl -Lko fdb-clients.deb https://www.foundationdb.org/downloads/6.2.22/ubuntu/installers/foundationdb-clients_6.2.22-1_amd64.deb && \
  apt-get install ./fdb-clients.deb && \
  rm -f fdb-clients.deb && \
  curl -Lko fdb-server.deb https://www.foundationdb.org/downloads/6.2.22/ubuntu/installers/foundationdb-server_6.2.22-1_amd64.deb && \
  apt-get install ./fdb-server.deb -y && \
  rm -f fdb-server.deb

RUN apt-get install git -y

ENTRYPOINT []

CMD []
