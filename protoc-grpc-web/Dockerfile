FROM debian:stretch-slim

RUN \
  apt-get update && \
  apt-get install -y curl unzip && \
  rm -rf /var/lib/apt/lists/*

RUN \ 
  mkdir /tmp/download && \
  cd /tmp/download && \
  curl -Lo protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/protoc-3.14.0-linux-x86_64.zip && \
  unzip protoc.zip -d /usr/local && \
  ls -la /usr/local/bin/protoc && \
  ls -la /usr/local/include/google && \
  rm -Rf *

RUN \
  curl -Lo /usr/local/bin/protoc-gen-grpc-web https://github.com/grpc/grpc-web/releases/download/1.2.1/protoc-gen-grpc-web-1.2.1-linux-x86_64 && \
  chmod +x /usr/local/bin/protoc-gen-grpc-web

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]