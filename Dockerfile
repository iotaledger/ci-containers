FROM alpine:latest

ENV ANSIBLE_VERSION=2.7.1

RUN apk update && \
    apk add --no-cache curl && \
    apk add --no-cache openssh && \
    apk add --no-cache jq && \
    apk add --no-cache python3 python3-dev && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \ 
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    apk add --no-cache openssl ca-certificates && \
    apk add --no-cache  --virtual build-dependencies \
      python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip && \
    pip install ansible==$ANSIBLE_VERSION && \
    apk del build-dependencies && \
    rm -r /root/.cache && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

COPY ./docker-entrypoint.sh /
ENTRYPOINT  [ "/docker-entrypoint.sh" ] 
