#!/bin/bash
set -e
docker run -it --rm -v tf:/tf --env DO_TOKEN=$1 bee42/terraform destroy
rm cluster.yml private_key kube_config_cluster.yml
