FROM shopstic/curl-tar-unzip:1.0.1 as deno

ARG PACKAGE_VERSION

RUN \
  mkdir /tmp/deno && \
  cd /tmp/deno && \
  curl -Lo ./deno.zip https://github.com/denoland/deno/releases/download/v1.8.3/deno-x86_64-unknown-linux-gnu.zip && \
  unzip ./deno.zip && \
  cp ./deno /usr/bin/deno && \
  chmod +x /usr/bin/deno && \
  rm -Rf /tmp/deno

FROM scratch
COPY --from=deno /usr/bin/deno /usr/bin/deno