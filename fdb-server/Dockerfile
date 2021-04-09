ARG PACKAGE_VERSION

FROM shopstic/fdb-base:${PACKAGE_VERSION}

COPY ./entrypoint.sh /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]
