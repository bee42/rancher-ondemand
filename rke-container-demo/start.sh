#!/bin/bash
set -e
make build build-rke build-helm

docker run -it --rm -v tf:/tf --env DO_TOKEN=$1 bee42/terraform apply
docker run -it --rm -v tf:/tf --env DO_TOKEN=$1 bee42/terraform output cluster_template > cluster.yml
docker run -it --rm -v tf:/tf --env DO_TOKEN=$1 bee42/terraform output ssh_private_key > private_key
docker run -it --rm -v $(pwd):/rke -v $(pwd)/private_key:/tf/.ssh/cluster_ed25519 bee42/rke rke up --config cluster.yml
docker run -v $(pwd)/kube_config_cluster.yml:/root/.kube/config --name kubectl-helm -it bee42/votingapp-deploy bash
