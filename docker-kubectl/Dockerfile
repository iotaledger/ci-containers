FROM alpine:3.8

ADD https://storage.googleapis.com/kubernetes-release/release/v1.9.5/bin/linux/amd64/kubectl /usr/local/bin/kubectl

ENV HOME=/config

RUN set -x && \
    apk add --no-cache curl ca-certificates jq && \
    chmod +x /usr/local/bin/kubectl && \
    \
    adduser kubectl -Du 2342 -h /config && \
    \
    kubectl version --client

USER kubectl

ENTRYPOINT ["/usr/local/bin/kubectl"]
