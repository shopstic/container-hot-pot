FROM golang:1.16.5-stretch as builder

ENV FDB_VERSION 6.3.15

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
  curl -L https://github.com/shopstic/fdb-prometheus-exporter/archive/108ec7d3bac1d7a2ea180531936378026aa920cf.tar.gz | tar -xzf - --strip-components=1 -C . && \
  go get -d -v ./... && \
  go install -v ./... && \
  rm -Rf /tmp/app

FROM debian:stretch-slim

COPY --from=builder /go/bin/fdb-prometheus-exporter /usr/bin/fdb-prometheus-exporter
COPY --from=shopstic/bin-dumb-init:1.2.2 / /
COPY --from=foundationdb/foundationdb:6.3.15 /usr/lib/libfdb_c.so /usr/lib/libfdb_c.so
COPY --from=foundationdb/foundationdb:6.3.15 /usr/lib/fdb/multiversion/libfdb_c_6.2.25.so /usr/lib/fdb/multiversion/libfdb_c_6.2.25.so

COPY ./entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
