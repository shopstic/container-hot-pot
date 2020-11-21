FROM openjdk:11.0.9-jre-slim as stage0

RUN \
  sed -i 's/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=5/g' /usr/local/openjdk-11/conf/security/java.security && \
  sed -i 's/networkaddress.cache.negative.ttl=10/networkaddress.cache.negative.ttl=0/g' /usr/local/openjdk-11/conf/security/java.security

RUN \
  apt-get update && \
  apt-get install -y curl

ENV FDB_VERSION "6.2.27"

RUN \
  curl -Lko fdb-clients.deb https://www.foundationdb.org/downloads/${FDB_VERSION}/ubuntu/installers/foundationdb-clients_${FDB_VERSION}-1_amd64.deb && \
  apt-get install ./fdb-clients.deb && \
  rm -f fdb-clients.deb
