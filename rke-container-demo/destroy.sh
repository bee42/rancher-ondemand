#!/bin/bash
set -e
docker run -it --rm -v tf:/tf --env DO_TOKEN=$1 bee42/terraform destroy

if [[ "$2" == "complete" ]]; then
  rm cluster.yml
  echo "removed cluster.yml"
  rm private_key
  echo "removed private_key"
  rm kube_config_cluster.yml
  echo "removed kube_config_cluster.yml"
  docker volume rm tf
  echo "removed docker volume tf"
  docker rmi bee42/rke:latest bee42/terraform:latest bee42/votingapp-deploy:latest
  echo "removed docker images"
fi
