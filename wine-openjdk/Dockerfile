FROM fedora:27
RUN \
  yum update -y && \
  yum install -y wine.i686 xorg-x11-server-Xvfb which && \
  yum clean all && \
  rm -rf /var/cache/yum

ENV JAVA_HOME="/etc/openjdk"
ENV PATH="/etc/openjdk/bin:${PATH}"

RUN \
  mkdir -p "${JAVA_HOME}" && \
  curl -L https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz | \
  tar -xzf - --strip-components=1 -C ${JAVA_HOME} && \
  sed -i 's/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/g' ${JAVA_HOME}/conf/security/java.security && \
  sed -i 's/networkaddress.cache.negative.ttl=10/networkaddress.cache.negative.ttl=0/g' ${JAVA_HOME}/conf/security/java.security

RUN \
  curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod a+x /usr/bin/dumb-init

ENV WINEPREFIX=/root/.wine

# ENV WINEARCH=win32

# COPY ./ ${WINEPREFIX}/

# RUN \
#   rm -f "${WINEPREFIX}/drive_c/users/NKTPRO/My Documents" && \
#   mkdir "${WINEPREFIX}/drive_c/users/NKTPRO/My Documents"
