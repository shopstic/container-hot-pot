FROM alpine:3.9 as builder

WORKDIR /opt

RUN apk --update --no-cache add --virtual build-dependencies alpine-sdk curl openssl openssl-dev zlib-dev \
    && curl "https://github.com/giltene/wrk2/archive/master.zip" -L -o master.zip \
    && unzip master.zip \
    && mv wrk2-master wrk2 \
    && cd wrk2 \
    && make \
    && mv wrk /usr/bin

FROM alpine:3.9
COPY --from=builder /usr/bin/wrk /usr/bin/wrk
RUN apk --update --no-cache add libgcc
CMD ["wrk"]
