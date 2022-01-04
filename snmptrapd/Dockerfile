FROM alpine:3.15.0

RUN apk --no-cache add net-snmp
RUN echo 'disableAuthorization yes' > /etc/snmp/snmptrapd.conf

ENTRYPOINT ["snmptrapd"]