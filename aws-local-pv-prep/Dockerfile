FROM debian:stretch-slim as builder

RUN \
  apt-get update && \
  apt-get -y install curl && \
  apt-get -y clean && \
  apt-get -y autoremove

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod +x /usr/bin/dumb-init

FROM debian:stretch-slim

RUN \
  apt-get update && \
  apt-get -y install nvme-cli && \
  apt-get -y clean && \
  apt-get -y autoremove

COPY --from=builder /usr/bin/dumb-init /usr/bin/dumb-init
COPY aws-local-pv-prep.sh /usr/bin/

ENTRYPOINT ["aws-local-pv-prep.sh"]