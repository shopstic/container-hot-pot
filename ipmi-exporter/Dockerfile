FROM shopstic/curl-tar-unzip:1.0.0 as ipmi-exporter

ARG PACKAGE_VERSION

RUN \
  curl -Lo - https://github.com/soundcloud/ipmi_exporter/releases/download/v${PACKAGE_VERSION}/ipmi_exporter-v${PACKAGE_VERSION}.linux-amd64.tar.gz | tar -xz --strip-components=1 -C /usr/bin/ && \
  chmod +x /usr/bin/ipmi_exporter

FROM debian:bullseye-20200908-slim
WORKDIR /
RUN apt-get update \
    && apt-get install freeipmi -y \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ipmi-exporter /usr/bin/ipmi_exporter /usr/bin/ipmi_exporter

EXPOSE 9290
ENTRYPOINT ["/usr/bin/ipmi_exporter"]
