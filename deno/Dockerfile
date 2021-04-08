FROM debian:bullseye-20200908-slim as build

ENV PATH=/root/.deno/bin/:$PATH

RUN \
  apt-get update && \
  apt-get install -y curl unzip

ARG PACKAGE_VERSION

RUN \
  curl -fsSL https://deno.land/x/install/install.sh | sh -s v${PACKAGE_VERSION}

FROM debian:bullseye-20200908-slim

COPY --from=build /root/.deno/bin/deno /usr/bin/deno



