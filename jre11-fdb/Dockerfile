FROM openjdk:11.0.7-jre-slim

RUN \
  sed -i 's/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=5/g' /usr/local/openjdk-11/conf/security/java.security && \
  sed -i 's/networkaddress.cache.negative.ttl=10/networkaddress.cache.negative.ttl=0/g' /usr/local/openjdk-11/conf/security/java.security

RUN \
  apt-get update && \
  apt-get install -y curl

RUN \
  curl -Lo fdb-clients.deb https://www.foundationdb.org/downloads/6.2.22/ubuntu/installers/foundationdb-clients_6.2.22-1_amd64.deb && \
  apt-get install ./fdb-clients.deb && \
  rm -f fdb-clients.deb
