FROM foundationdb/foundationdb:6.2.22

RUN \
  apt update && \
  apt install -y jq

WORKDIR /app
RUN \
  groupadd -r -g 1001 foundationdb && \
  useradd -r -s /bin/false -u 1001 -g 1001 foundationdb && \
  chown -R foundationdb:foundationdb /app

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod +x /usr/bin/dumb-init

RUN \
  curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.3/bin/linux/amd64/kubectl && \
  chmod a+x /usr/local/bin/kubectl

USER foundationdb:foundationdb

COPY ./entrypoint.sh /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]