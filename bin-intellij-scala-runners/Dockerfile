FROM shopstic/curl-tar-unzip:1.0.1 as runners

# Apache 2.0 license: https://plugins.jetbrains.com/plugin/1347-scala

RUN \
  mkdir /download && \
  cd /download && \
  curl -Lo plugin.zip "https://plugins.jetbrains.com/plugin/download?rel=true&updateId=118422" && \
  unzip plugin.zip && \
  mkdir /var/lib/intellij-scala-runners/ && \
  mv ./Scala/lib/runners.jar /var/lib/intellij-scala-runners/ && \
  rm -Rf /download

FROM scratch
COPY --from=runners /var/lib/intellij-scala-runners /var/lib/intellij-scala-runners