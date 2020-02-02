FROM centos:7

RUN yum update -y && yum install -y rsync openssh-clients curl bash && yum clean all
RUN \
  curl https://raw.githubusercontent.com/kadwanev/retry/master/retry -o /usr/bin/retry && \
  chmod +x /usr/bin/retry