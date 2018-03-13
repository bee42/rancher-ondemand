# Rancher Kubernetes On Demand

Install Rancher 2.0 Kubernetes on Demand with RKE

More information in our [blogpost](https://www.bee42.com/de/blog/Kubernetes_Cluster_mit_RKE_containerized/).

## Abstract

We want to install an Kubernetes-Cluster into the Digital Ocean Cloud. To automate this, we provision our infrastructure with terraform and deploy the cluster with Rancher Kubernetes Engine (RKE).

We only need three simple steps:

1. With terraform, create three nodes with docker installed.
1. The IP-Addresses of this nodes are injected into a default-config-file for RKE
1. Deploy Kubernetes-Cluster with RKE

At the end we have an Kubernetes-Cluster with three nodes functioning as control-plane, etcd and worker respectivly.

**Quickstart**
- configure Digital Ocean Account
- build containers
- exceute ```start.sh $DO_TOKEN```

## Architecture
![Architecture](/bee42-rke-tools.png)

## Prerequisites

### Digital Ocean Account

If you do not have an Digital Ocean account yet, please create one under https://www.digitalocean.com/

Terrafrom should communicate with the DO-Cloud, so we need two things which have to be configured in the Account-Settings:
  
* Generate an Access Token
  * https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2#HowToGenerateaPersonalAccessToken
  * Please copy the token to a text-file or similar when it is shown, we need it later!
* Add SSH-Key
  * https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets
  * Please take a note of the MD5-fingerprint of your ssh-key

### Build container

 ```
 make build
 make build rke
 ```

### Deploy Kubernetes

```start.sh $DO_TOKEN```

The Kubernetes-Cluster will be build in a few minutes, and a `.kube_config_cluster.yml` is saved to your working directory.

```

## ToDo's

* Use Private Network IP's for kubernetes componentes (internal_address)
* Setup a Digital Ocean Loadbalancer
  * https://github.com/digitalocean/digitalocean-cloud-controller-manager
  * https://thenewstack.io/tutorial-run-multi-node-kubernetes-cluster-digitalocean/
* Add more security
* ~~Use different terraform resources for controlplane/etcd and worker~~
* ~~Generate rke config with terraform and flexible numbers of controlplane master and workers~~
* Use calico network at digitalocean?
* Validate installation with serverspec or goss
  * https://github.com/aelsabbahy/goss
  * https://medium.com/@aelsabbahy/docker-1-12-kubernetes-simplified-health-checks-and-container-ordering-with-goss-fa8debbe676c
  * http://serverspec.org/
  * http://www.infrabricks.de/blog/2014/09/10/docker-container-mit-serverspec-testen/
  * http://www.infrabricks.de/blog/2015/04/16/docker-container-mit-serverspetesten-teil-2/
* Check update new rancher release
* Add terraform KVM Setup
* ~~Add architecture design picture~~
* Add some examples
  * kubernetes dashboard
  * add ingress traefik or nginx loadbalancer
  * setup helm at different namespaces
  * setup service mesh

## Links

* https://medium.com/@kenfdev/deploying-kubernetes-on-premise-with-rke-and-deploying-openfaas-on-it-part-1-69a35ddfa507
* https://github.com/rancher/rke
* https://schd.ws/hosted_files/kccncna17/d8/Hacking%20and%20Hardening%20Kubernetes%20By%20Example%20v2.pdf	
* https://github.com/garethr/kubetest
* https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean

