FROM alpine:3.15.0

COPY --from=docker.io/shopstic/bin-dumb-init:1.2.2 /usr/bin/dumb-init /usr/bin/dumb-init
RUN apk add netcat-openbsd

ENTRYPOINT ["dumb-init", "--", "nc"]
