FROM alpine:latest

RUN apk add curl && \
  curl -o /root/fdb.deb https://www.foundationdb.org/downloads/6.2.15/ubuntu/installers/foundationdb-clients_6.2.15-1_amd64.deb

FROM openjdk:11.0.6-jre-slim

COPY --from=0 /root/fdb.deb /root/fdb.deb
RUN apt install /root/fdb.deb && \
  rm -f /root/fdb.deb