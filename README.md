# Rancher Kubernetes On Demand

Install Rancher 2.0 Kubernetes on Demand with RKE

## Abstract

We want to install an Kubernetes-Cluster into the Digital Ocean Cloud. To automate this, we provision our infrastructure with terraform and deploy the cluster with Rancher Kubernetes Engine (RKE).

## Plan

1. With terraform, create three nodes with docker installed.
1. Generate cluster-template-file for rke
1. Deploy Kubernetes-Cluster with RKE

## Solutions

We have two different versions available:

1. [First version](https://github.com/bee42/rancher-ondemand/tree/master/rke-demo) requires you to install tools locally and uses some scripts
1. [Second version](https://github.com/bee42/rancher-ondemand/tree/master/rke-container-demo) is containerized and leverages the use of terraform, only docker ist required on your machine

