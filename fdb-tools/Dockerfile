FROM mcr.microsoft.com/dotnet/core/sdk:3.1.102-bionic

ARG PACKAGE_VERSION
ARG DOTNET_CLIENT_VERSION=22d2c62b00b4ca009977de9dbae916c80d242d27

RUN mkdir /tmp/fdb && \
  cd /tmp/fdb && \
  curl -Lo foundationdb-dotnet-client.tar.gz https://github.com/shopstic/foundationdb-dotnet-client/archive/${DOTNET_CLIENT_VERSION}.tar.gz && \
  tar -xzf foundationdb-dotnet-client.tar.gz --strip-components=1 && \
  dotnet publish FdbTop -c Release -r linux-x64 --framework=netcoreapp3.1 --output /out --self-contained false && \
  dotnet publish FdbShell -c Release -r linux-x64 --framework=netcoreapp3.1 --output /out --self-contained false && \
  rm -Rf /tmp/fdb && \
  mv /out/FdbTop /out/fdbtop && \
  mv /out/FdbShell /out/fdbshell

RUN mkdir /tmp/fdb && \
  cd /tmp/fdb && \
  curl -Lo fdb.deb https://www.foundationdb.org/downloads/${PACKAGE_VERSION}/ubuntu/installers/foundationdb-clients_${PACKAGE_VERSION}-1_amd64.deb

FROM mcr.microsoft.com/dotnet/core/runtime:3.1.2-bionic

RUN \
  apt-get update && \
  apt-get install -y jq && \
  rm -rf /var/lib/apt/lists/*

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod +x /usr/bin/dumb-init

ENV K8S_VERSION "1.19.2"

RUN \
  curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl && \
  chmod a+x /usr/bin/kubectl

COPY --from=0 /tmp/fdb/fdb.deb /tmp/fdb/fdb.deb

RUN apt-get install /tmp/fdb/fdb.deb && \
  rm -Rf /tmp/fdb

COPY --from=0 /out/* /usr/bin/

USER foundationdb:foundationdb

ADD ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
