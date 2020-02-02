FROM quay.io/prometheus/golang-builder:1.13-base AS builder

RUN \
  git clone --depth=1 https://github.com/soundcloud/ipmi_exporter.git /tmp/app && \
  cd /tmp/app && \
  make && \
  cp /tmp/app/ipmi_exporter /bin/ipmi_exporter && \
  rm -Rf /tmp/app

# Container image
FROM debian:stretch-slim
WORKDIR /
RUN apt-get update \
    && apt-get install freeipmi-tools -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /bin/ipmi_exporter /bin/ipmi_exporter

EXPOSE 9290
ENTRYPOINT ["/bin/ipmi_exporter"]