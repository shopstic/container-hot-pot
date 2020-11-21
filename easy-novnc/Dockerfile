FROM shopstic/curl-tar-unzip:1.0.1 as dumb-init

ENV DUMB_INIT_VERSION "1.2.2"

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod a+x /usr/bin/dumb-init

FROM shopstic/curl-tar-unzip:1.0.1 as easy-novnc

ENV EASY_NOVNC_VERSION "1.1.0"

RUN \
  curl -Lo /usr/bin/easy-novnc https://github.com/pgaskin/easy-novnc/releases/download/v${EASY_NOVNC_VERSION}/easy-novnc_linux-64bit && \
  chmod +x /usr/bin/easy-novnc

FROM debian:bullseye-20201012-slim

COPY --from=dumb-init /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=easy-novnc /usr/bin/easy-novnc /usr/bin/easy-novnc

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
EXPOSE 80

CMD ["/usr/bin/easy-novnc", "--addr", ":80", "--host", "localhost", "--port", "5900", "--no-url-password", "--novnc-params", "resize=remote"]
