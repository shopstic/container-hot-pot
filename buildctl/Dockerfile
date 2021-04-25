ARG PACKAGE_VERSION

FROM shopstic/bin-buildctl:${PACKAGE_VERSION} as bin-buildctl
FROM shopstic/bin-docker:20.10.6 as bin-docker

FROM alpine:3.13.5

COPY --from=bin-buildctl / /
COPY --from=bin-docker / /

RUN \
  apk update && \
  apk add bash parallel