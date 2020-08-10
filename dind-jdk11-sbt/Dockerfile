FROM docker:stable-dind

RUN \
  apk add bash && \
  apk add openjdk11 && \
  apk add curl

ARG PACKAGE_VERSION

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

ENV PATH="$PATH:/sbt/bin"

RUN sbt sbtVersion

ENTRYPOINT []

CMD []
