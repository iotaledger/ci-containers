#!/bin/sh

set -euo pipefail

if [ ! -f $HOME/.ssh/id_rsa ]; then
        ssh-keygen -q -t rsa -b 4096 -f $HOME/.ssh/id_rsa -N '' 
fi

echo '{ "public_key" : "'$(cat $HOME/.ssh/id_rsa.pub)'" }' > $HOME/.ssh/id_rsa.pub.json

curl -s \
        --header "X-Vault-Token: $DOCKER_VAULT_TOKEN" \
        --request POST \
        --data @$HOME/.ssh/id_rsa.pub.json \
$SSH_CLIENT_SIGNER_ADDR/sign/signer \
| jq -r '.data .signed_key' > $HOME/.ssh/id_rsa-cert.pub

echo "@cert-authority *.iota.cafe $(curl $SSH_HOST_SIGNER_ADDR/public_key)" >> $HOME/.ssh/known_hosts
echo "@cert-authority *.iota.org $(curl $SSH_HOST_SIGNER_ADDR/public_key)" >> $HOME/.ssh/known_hosts
echo "@cert-authority *.sadj.co $(curl $SSH_HOST_SIGNER_ADDR/public_key)" >> $HOME/.ssh/known_hosts

exec "$@"
