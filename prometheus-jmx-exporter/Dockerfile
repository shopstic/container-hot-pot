FROM alpine
ARG PACKAGE_VERSION
RUN apk --no-cache add curl
RUN mkdir /data && \
  curl -Lo /data/jmx_prometheus_javaagent.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${PACKAGE_VERSION}/jmx_prometheus_javaagent-${PACKAGE_VERSION}.jar

FROM alpine
ADD ./entrypoint.sh /entrypoint.sh
COPY --from=0 /data /data
ENTRYPOINT ["/entrypoint.sh"]
