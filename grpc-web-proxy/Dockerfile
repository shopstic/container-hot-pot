FROM shopstic/curl-tar-unzip:1.0.1 as grpc-web-proxy

ENV GRPC_WEB_PROXY_VERSION "0.13.0"

RUN \
  mkdir /tmp/download && \
  cd  /tmp/download && \
  curl -Lo grpcwebproxy.zip https://github.com/improbable-eng/grpc-web/releases/download/v${GRPC_WEB_PROXY_VERSION}/grpcwebproxy-v${GRPC_WEB_PROXY_VERSION}-linux-x86_64.zip && \
  unzip grpcwebproxy.zip && \
  mv ./dist/grpcwebproxy* /usr/bin/grpcwebproxy && \
  chmod +x /usr/bin/grpcwebproxy && \
  rm -Rf /tmp/download

FROM alpine:3.12.3

COPY --from=grpc-web-proxy /usr/bin/grpcwebproxy /usr/bin/grpcwebproxy
