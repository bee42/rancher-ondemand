#!/bin/bash

TF_PLAN=dockernodes.tfplan

#terraform validate || exit 1
#terraform plan -out $TF_PLAN|| exit 2
#terraform apply $TF_PLAN || exit 3
./create_config.py || exit 4
rke up || exit 5
echo Kubernetes-Cluster is running.


