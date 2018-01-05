#!/bin/bash
SSH_KEYNAME=${SSH_KEYNAME:-"cluster_ed25519"}
SSH_KEY_PATH=$HOME/.ssh/$SSH_KEYNAME

if [[ "$1" == "apply" ]]; then
    mkdir -p $HOME/.ssh
    ssh-keygen -t ed25519 \
    -f ${SSH_KEY_PATH} \
    -q -N "" -C "rke@bee42.com"
    exec terraform $1 -auto-approve -var do_token=$DO_TOKEN -var ssh_cluster_private_key=$SSH_KEY_PATH -var ssh_cluster_public_key=$SSH_KEY_PATH.pub
    exit 0
fi
if [[ "$1" == "destroy" ]]; then
    exec terraform $1 -force -var do_token=$DO_TOKEN -var ssh_cluster_private_key=$SSH_KEY_PATH -var ssh_cluster_public_key=$SSH_KEY_PATH.pub
    exit 0
fi

exec terraform "$@"
