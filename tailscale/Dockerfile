FROM shopstic/curl-tar-unzip:1.0.1 as dumb-init

ENV DUMB_INIT_VERSION "1.2.2"

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod a+x /usr/bin/dumb-init

# yq ------------------------------------------------------------------
FROM shopstic/curl-tar-unzip:1.0.1 as jq

ENV JQ_VERSION "1.6"

RUN \
  curl -Lo /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
  chmod +x /usr/bin/jq

FROM ubuntu:20.04

ARG PACKAGE_VERSION

VOLUME /var/lib/tailscale

RUN apt-get update -y && \
    apt-get install -y curl gpg && \
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | apt-key add - && \
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update -y && \
    apt-get install -y tailscale=${PACKAGE_VERSION}

COPY --from=dumb-init /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=jq /usr/bin/jq /usr/bin/jq
COPY ./entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["entrypoint.sh"]