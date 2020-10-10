FROM debian:bullseye-20200908-slim as build

ENV PATH=/root/.deno/bin/:$PATH

ARG PACKAGE_VERSION

RUN \
  apt-get update && \
  apt-get install -y curl unzip

RUN \
  curl -fsSL https://deno.land/x/install/install.sh | sh -s v${PACKAGE_VERSION}

FROM debian:bullseye-20200908-slim as app

ENV PATH=/root/.deno/bin/:$PATH

COPY --from=build /root/.deno /root/.deno



