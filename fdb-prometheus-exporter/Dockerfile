ARG FDB_VERSION=6.3.12
ARG FDB_PREVIOUS_VERSION=6.2.30

FROM golang:1.13.6-stretch as builder

ARG FDB_VERSION
ARG FDB_PREVIOUS_VERSION

RUN \
  apt update && \
  apt install -y dnsutils

RUN \
  mkdir /tmp/fdb && \
  cd /tmp/fdb && \
  curl -Lo fdb.deb "https://www.foundationdb.org/downloads/${FDB_VERSION}/ubuntu/installers/foundationdb-clients_${FDB_VERSION}-1_amd64.deb" && \
  curl -Lo /libfdb_c_${FDB_PREVIOUS_VERSION}.so "https://foundationdb-origin.apple.com/downloads/${FDB_PREVIOUS_VERSION}/linux/libfdb_c_${FDB_PREVIOUS_VERSION}.so" && \
  ls -la . && \
  dpkg -i fdb.deb && \
  rm -Rf /tmp/fdb

RUN \
  mkdir /tmp/app && \
  cd /tmp/app && \
  curl -L https://github.com/shopstic/fdb-prometheus-exporter/archive/108ec7d3bac1d7a2ea180531936378026aa920cf.tar.gz | tar -xzf - --strip-components=1 -C . && \
  go get -d -v ./... && \
  go install -v ./... && \
  rm -Rf /tmp/app

FROM shopstic/curl-tar-unzip:1.0.0 as dumb-init

ENV DUMB_INIT_VERSION "1.2.2"

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 && \
  chmod +x /usr/bin/dumb-init

FROM debian:stretch-slim
ARG FDB_PREVIOUS_VERSION

COPY --from=dumb-init /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=builder /go/bin/fdb-prometheus-exporter /usr/bin/fdb-prometheus-exporter
COPY --from=builder /usr/lib/libfdb_c.so /usr/lib/libfdb_c.so
COPY --from=builder /libfdb_c_${FDB_PREVIOUS_VERSION}.so /fdb-previous-libs/libfdb_c_${FDB_PREVIOUS_VERSION}.so

COPY ./entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
