FROM alpine:3.10

ARG PACKAGE_VERSION

ENV KUBECTL_VERSION="1.16.2"
ENV HELM_VERSION="2.16.1"
ENV HELM_DIFF_VERSION="2.11.0+5"
ENV HELM_SECRETS_VERSION="2.0.2"
ENV SOPS_VERSION="3.4.0"
ENV OQ_VERSION="0.2.1"

RUN apk add --no-cache ca-certificates bash git openssh curl gnupg dumb-init jq
RUN apk -v --update add \
        python py-pip \
        && \
    pip install --upgrade awscli==1.17.5 && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

RUN wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && wget -q https://github.com/roboll/helmfile/releases/download/v${PACKAGE_VERSION}/helmfile_linux_amd64 -O /usr/local/bin/helmfile \
    && chmod +x /usr/local/bin/helmfile \
    && wget -q https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux -O /usr/local/bin/sops \
    && chmod +x /usr/local/bin/sops \
    && wget -q https://github.com/Blacksmoke16/oq/releases/download/v${OQ_VERSION}/oq-${OQ_VERSION}-linux-x86_64 -O /usr/local/bin/oq \
    && chmod +x /usr/local/bin/oq

WORKDIR /helm

ENV HELM_HOME="/helm"

RUN mkdir ${HELM_HOME}/plugins \
  && helm plugin install https://github.com/databus23/helm-diff --version v${HELM_DIFF_VERSION} \
  && helm plugin install https://github.com/futuresimple/helm-secrets --version v${HELM_SECRETS_VERSION}

ENTRYPOINT ["/usr/bin/dumb-init", "--"]