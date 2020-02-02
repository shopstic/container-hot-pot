FROM golang:1.13.6-stretch as builder

ARG PACKAGE_VERSION

WORKDIR /app

RUN \
  wget -O - https://github.com/coreos/prometheus-operator/archive/v${PACKAGE_VERSION}.tar.gz | tar -xz -C . --strip-components=1

RUN \
  LINE=$(awk '/package main/{ print NR; exit }' ./cmd/prometheus-config-reloader/main.go) && \
  sed -i "$((LINE + 1))iimport \"time\"" ./cmd/prometheus-config-reloader/main.go

RUN \
  LINE=$(awk '/rel := reloader.New/{ print NR; exit }' ./cmd/prometheus-config-reloader/main.go) && \
  sed -i "$((LINE + 1))irel.WithWatchInterval(5 * time.Second)" ./cmd/prometheus-config-reloader/main.go

RUN \
  make prometheus-config-reloader

FROM debian:stretch-slim

COPY --from=builder /app/prometheus-config-reloader /bin/prometheus-config-reloader

ENTRYPOINT ["/bin/prometheus-config-reloader"]
