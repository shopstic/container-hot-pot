ARG PACKAGE_VERSION="6.2.29"

# kubectl ------------------------------------------------------------------
FROM shopstic/curl-tar-unzip:1.0.1 as kubectl

ENV K8S_VERSION "1.19.7"

RUN \
  curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x /usr/bin/kubectl

# dumb-init ------------------------------------------------------------------
FROM shopstic/curl-tar-unzip:1.0.0 as dumb-init

ENV DUMB_INIT_VERSION "1.2.2"

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 && \
  chmod +x /usr/bin/dumb-init

# yq ------------------------------------------------------------------
FROM shopstic/curl-tar-unzip:1.0.0 as jq

ENV JQ_VERSION "1.6"

RUN \
  curl -Lo /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
  chmod +x /usr/bin/jq

FROM foundationdb/foundationdb:${PACKAGE_VERSION}

WORKDIR /app
RUN \
  groupadd -r -g 1001 foundationdb && \
  useradd -r -s /bin/false -u 1001 -g 1001 foundationdb && \
  chown -R foundationdb:foundationdb /app

USER foundationdb:foundationdb

COPY --from=kubectl /usr/bin/kubectl /usr/bin/kubectl
COPY --from=dumb-init /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=jq /usr/bin/jq /usr/bin/jq