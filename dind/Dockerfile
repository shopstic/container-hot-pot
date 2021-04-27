ARG PACKAGE_VERSION

FROM shopstic/bin-dumb-init:1.2.2 as bin-dumb-init
FROM docker:${PACKAGE_VERSION}-dind

COPY --from=bin-dumb-init / / 

COPY ./entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]