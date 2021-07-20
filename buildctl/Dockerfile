ARG PACKAGE_VERSION

FROM shopstic/bin-buildctl:${PACKAGE_VERSION} as bin-buildctl
FROM shopstic/bin-docker:20.10.6 as bin-docker
FROM shopstic/bin-jq:1.6 as bin-jq

FROM ubuntu:20.04

RUN \
  apt-get update && \
  apt-get install -y ca-certificates parallel curl

COPY --from=bin-buildctl / /
COPY --from=bin-docker / /
COPY --from=bin-jq / /
