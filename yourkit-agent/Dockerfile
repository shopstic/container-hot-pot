FROM alpine:3.13.5

ADD ./libyjpagent.so /data/libyjpagent.so
ADD ./license-redist.txt /data/license-redist.txt
ADD ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]