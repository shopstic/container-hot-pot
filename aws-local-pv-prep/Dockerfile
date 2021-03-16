FROM debian:stretch-slim as builder

RUN \
  apt-get update && \
  apt-get -y install curl && \
  apt-get -y clean && \
  apt-get -y autoremove

RUN \
  curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kubectl && \
  chmod +x /usr/bin/kubectl

FROM debian:stretch-slim

RUN \
  apt-get update && \
  apt-get -y install nvme-cli && \
  apt-get -y clean && \
  apt-get -y autoremove

COPY --from=builder /usr/bin/kubectl /usr/bin/kubectl
COPY ./scripts/* /usr/bin/

ENTRYPOINT ["prep-individual-volumes.sh"]