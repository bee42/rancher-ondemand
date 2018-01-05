#!/bin/bash
SSH_KEYNAME=${SSH_KEYNAME:-"cluster_ed25519"}
SSH_KEY_PATH=$HOME/.ssh/$SSH_KEYNAME

mkdir -p $HOME/.ssh
ssh-keygen -t ed25519 \
-f ${SSH_KEY_PATH} \
-q -N "" -C "rke@bee42.com"


terraform apply -var ssh_cluster_private_key=$SSH_KEY_PATH -var ssh_cluster_public_key=$SSH_KEY_PATH.pub
