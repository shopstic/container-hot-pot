FROM shopstic/curl-tar-unzip:1.0.0 as builder

RUN \
  apt update && \
  apt install -y cmake && \
  mkdir /build && \
  cd /build && \
  curl -L https://gitlab.com/cunity/tinish/-/archive/master/tinish-master.tar.gz | tar -xzf - --strip-components=1 -C . && \
  cmake -H. -Bbuild && \
  cmake --build build && \
  cp ./build/bash /bin/tinish && \
  rm -Rf /build

FROM scratch
COPY --from=builder /bin/tinish /bin/tinish
