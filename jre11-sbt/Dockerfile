FROM openjdk:11-jre-slim as stage0

ARG PACKAGE_VERSION

RUN \
  apt-get update && \
  apt-get install -y curl unzip

RUN \
  mkdir /sbt && \
  cd /sbt && \
  curl -Lo sbt.zip https://github.com/sbt/sbt/releases/download/v${PACKAGE_VERSION}/sbt-${PACKAGE_VERSION}.zip && \
  unzip sbt.zip && rm -Rf sbt.zip && rm -Rf sbt/lib && mv /sbt/sbt/* /sbt/ && rm -Rf sbt && \
  chmod a+x /sbt/bin/sbt

RUN \
  cd /sbt/bin && \
  curl -Lo sbt-client.gz https://github.com/cb372/sbt-client/releases/download/v0.1.2/sbt-client-v0.1.2-x86_64-unknown-linux-gnu.gz && \
  gunzip sbt-client.gz && \
  rm -f sbt-client.gz && \
  chmod +x sbt-client

FROM openjdk:11-jre-slim
ENV PATH="$PATH:/sbt/bin"
COPY --from=stage0 /sbt /sbt
RUN sbt sbtVersion
ENTRYPOINT []
CMD []
