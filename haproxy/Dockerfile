FROM haproxy:2.4.0

ENV HAPROXY_USER haproxy

RUN groupadd --gid 49971 --system ${HAPROXY_USER} && \
  useradd --system --uid 49971 --gid ${HAPROXY_USER} ${HAPROXY_USER} && \
  mkdir --parents /var/lib/${HAPROXY_USER} && \
  chown -R ${HAPROXY_USER}:${HAPROXY_USER} /var/lib/${HAPROXY_USER}

USER haproxy:haproxy

CMD ["haproxy", "-db", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
