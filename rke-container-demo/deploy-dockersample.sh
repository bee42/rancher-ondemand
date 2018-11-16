#!/bin/bash
kubectl create namespace vote
kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
helm init
echo "waiting for tiller pod..."
sleep 20s
helm install example-voting-app/k8s-specifications/
kubectl get pods --namespace=vote
