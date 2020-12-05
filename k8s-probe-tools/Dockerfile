FROM shopstic/curl-tar-unzip:1.0.0 as grpc-health-probe

ENV GRPC_HEALTH_PROBE_VERSION "0.3.4"

RUN \
  curl -Lo /usr/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/v${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
  chmod +x /usr/bin/grpc_health_probe

FROM shopstic/curl-tar-unzip:1.0.0 as prom2json

ENV PROM2JSON_VERSION "1.3.0"

RUN \
  curl -Lo - https://github.com/prometheus/prom2json/releases/download/v${PROM2JSON_VERSION}/prom2json-${PROM2JSON_VERSION}.linux-amd64.tar.gz | tar -xz --strip-components=1 -C /usr/bin/ && \
  chmod +x /usr/bin/prom2json

FROM shopstic/curl-tar-unzip:1.0.0 as jq

ENV JQ_VERSION "1.6"

RUN \
  curl -Lo /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
  chmod +x /usr/bin/jq

FROM shopstic/curl-tar-unzip:1.0.0 as curl

ENV CURL_VERSION "7.63.0"

RUN \
  curl -Lo /usr/bin/curl https://github.com/dtschan/curl-static/releases/download/v${CURL_VERSION}/curl && \
  chmod +x /usr/bin/curl

FROM alpine:3.12.1

WORKDIR /tools
COPY --from=grpc-health-probe /usr/bin/grpc_health_probe /tools/grpc_health_probe
COPY --from=jq /usr/bin/jq /tools/jq
COPY --from=prom2json /usr/bin/prom2json /tools/prom2json
COPY --from=curl /usr/bin/curl /tools/curl

COPY ./prom2jq /tools/prom2jq

ENTRYPOINT ["sh", "-c", "cp /tools/* /k8s-probe-tools"]
