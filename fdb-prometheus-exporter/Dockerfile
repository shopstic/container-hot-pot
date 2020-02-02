FROM golang:1.13.6-stretch as builder

ARG FDB_VERSION=6.2.15

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
  curl -Lo repo.tar.gz https://github.com/shopstic/fdb-prometheus-exporter/archive/fbfb016abae4ce94905b5b9a584ed6a166e16cf1.tar.gz && \
  tar -xzf repo.tar.gz --strip-components=1 -C . && \
  rm -f repo.tar.gz && \
  go get -d -v ./... && \
  go install -v ./... && \
  rm -Rf /tmp/app

FROM debian:stretch-slim

COPY --from=builder /go/bin/fdb-prometheus-exporter /fdb-prometheus-exporter
COPY --from=builder /usr/lib/libfdb_c.so /usr/lib/libfdb_c.so

CMD ["/fdb-prometheus-exporter"]