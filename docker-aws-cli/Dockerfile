FROM docker:19.03.1

RUN apk -v --update add \
        python py-pip \
        && \
    pip install --upgrade awscli==1.17.5 && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*