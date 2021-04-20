ARG PACKAGE_VERSION

FROM summerwind/actions-runner-dind:${PACKAGE_VERSION}

USER root
RUN \
  sed -i 's/exec \.\/bin\/runsvc\.sh --once/exec .\/bin\/runsvc.sh/' /usr/local/bin/entrypoint.sh

USER runner