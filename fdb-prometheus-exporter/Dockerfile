FROM golang:1.13.6-stretch as builder

ARG FDB_VERSION=6.2.27

RUN \
  apt update && \
  apt install -y dnsutils

RUN \
  mkdir /tmp/fdb && \
  cd /tmp/fdb && \
  curl -Lo fdb.deb "https://www.foundationdb.org/downloads/${FDB_VERSION}/ubuntu/installers/foundationdb-clients_${FDB_VERSION}-1_amd64.deb" && \
  ls -la . && \
  dpkg -i fdb.deb && \
  rm -Rf /tmp/fdb

RUN \
  mkdir /tmp/app && \
  cd /tmp/app && \
  curl -L https://github.com/shopstic/fdb-prometheus-exporter/archive/fbfb016abae4ce94905b5b9a584ed6a166e16cf1.tar.gz | tar -xzf - --strip-components=1 -C . && \
  go get -d -v ./... && \
  go install -v ./... && \
  rm -Rf /tmp/app

FROM shopstic/curl-tar-unzip:1.0.0 as dumb-init

ENV DUMB_INIT_VERSION "1.2.2"

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 && \
  chmod +x /usr/bin/dumb-init

FROM debian:stretch-slim

COPY --from=dumb-init /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=builder /go/bin/fdb-prometheus-exporter /usr/bin/fdb-prometheus-exporter
COPY --from=builder /usr/lib/libfdb_c.so /usr/lib/libfdb_c.so

COPY ./entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
