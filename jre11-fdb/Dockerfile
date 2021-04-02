FROM shopstic/curl-tar-unzip:1.0.1 as dumb-init

ENV DUMB_INIT_VERSION "1.2.2"

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod a+x /usr/bin/dumb-init

FROM shopstic/curl-tar-unzip:1.0.1 as fdb-clients

ENV FDB_VERSION "6.2.29"

RUN \
  curl -Lko /tmp/fdb-clients.deb https://www.foundationdb.org/downloads/${FDB_VERSION}/ubuntu/installers/foundationdb-clients_${FDB_VERSION}-1_amd64.deb

FROM openjdk:11.0.10-jre-slim as stage0

RUN \
  sed -i 's/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=5/g' /usr/local/openjdk-11/conf/security/java.security && \
  sed -i 's/networkaddress.cache.negative.ttl=10/networkaddress.cache.negative.ttl=1/g' /usr/local/openjdk-11/conf/security/java.security

COPY --from=dumb-init /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=fdb-clients /tmp/fdb-clients.deb /tmp/fdb-clients.deb

RUN \
  apt-get install /tmp/fdb-clients.deb && \
  rm -f /tmp/fdb-clients.deb

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]