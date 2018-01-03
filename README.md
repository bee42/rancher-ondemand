# Rancher Kubernetes On Demand

Install Rancher 2.0 Kubernetes on Demand with RKE

## Abstract

We want to install an Kubernetes-Cluster into the Digital Ocean Cloud. To automate this, we provision our infrastructure with terraform and deploy the cluster with Rancher Kubernetes Engine (RKE).

We only need three simple steps:

1. With terraform, create three nodes with docker installed.
1. The IP-Addresses of this nodes are injected into a default-config-file for RKE
1. Deploy Kubernetes-Cluster with RKE

At the end we have an Kubernetes-Cluster with three nodes functioning as control-plane, etcd and worker respectivly.

**Quickstart**
- configure Digital Ocean Account
- install terraform and RKE
- clone repo and adjust environment-variables according to your environment
- exceute [quickstart.sh](./rke-demo/quickstart.sh)


## Prerequisites
### Terraform by HashiCorp

With terraform, we can write our infrastructure as code. If you don't already have terraform installed, please have a quick look at https://www.terraform.io/intro/getting-started/install.html

Install at your MAC with:

```
$ brew install terraform
```

### Rancher Kubernetes Engine (RKE)

Get it from https://github.com/rancher/rke, where you can download the binary for your architecture.
Please rename it to rke and make it available by setting the PATH-Variable of your environment.

Install at your MAC with:

```
$ sudo curl -sL https://github.com/rancher/rke/releases/download/v0.0.9-dev/rke_darwin-amd64 > /usr/local/bin/rke
$ sudo chmod +x /usr/local/bin/rke
```

### Digital Ocean Account

If you do not have an Digital Ocean account yet, please create one under https://www.digitalocean.com/

Terrafrom should communicate with the DO-Cloud, so we need two things which have to be configured in the Account-Settings:
  
* Generate an Access Token
  * https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2#HowToGenerateaPersonalAccessToken
  * Please copy the token to a text-file or similar when it is shown, we need it later!
* Add SSH-Key
  * https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets
  * Please take a note of the MD5-fingerprint of your ssh-key

## Configure Terraform

### Set variables

Terraform needs some parameters to securely communicate with your Digtal Ocean Account. There are different ways to do this, here we pass them as environment-variables:

    export TF_VAR_do_token=YOUR_DIGITALOCEAN_ACCESS_TOKEN
    export TF_VAR_pvt_key=$HOME/.ssh/id_rsa
    export TF_VAR_pub_key=${TF_VAR_pvt_key}.pub
    export TF_VAR_ssh_fingerprint=`ssh-keygen -E md5 -lf ${TF_VAR_pub_key} | awk '{print $2}' | sed 's/^MD5://g'`

__Hint__: terraform only supports ssh keys without password protection!

```
$ ssh-keygen -t ed25519 -f $HOME/.ssh/digitalocean-bee42-com -q -N "" -C "peter.rossbach@bee42.com"
```

__Example__: [set-tf-env-example.sh](./rke-demo/set-tf-env-example.sh)

You have to replace the values according to your environment. If the one-liner to generate the MD5-fingerprint does not work for you (only tested on Ubuntu 16.04), you should simply use your MD5-fingerprint from the notes you've taken before.  :)


Upload your SSH key to digital ocean (Topic security)

Check your Digital Ocean access with:

```
$ curl -sL -X GET \
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer $TF_VAR_do_token" \
 "https://api.digitalocean.com/v2/regions" | jq "."
```

### Create files

Now we create some files for terraform to describe our desired infrastructure.

First we need an provider to tell terraform which cloud we connect to:

__Example__: [provider.tf](./rke-demo/provider.tf)

Then we create a file describing our three docker-nodes, on which the Kubernetes-Cluster will be installed later:
* resource: Name, Baseimage (here: Ubuntu 16.04), RAM, Region etc.
* connection: How can terraform connect to the created droplet
* provision: Which commands should be executed, e.g. to install docker 

__Example__: [dockernodes.tf](./rke-demo/dockernodes.tf)

### Initialize terraform

Next we have to initialize terraform simply with
```bash
terraform init
```
To verify that all files are syntactically correct, please excute
```bash
terraform validate
```
### Create infrastructure

* We let terraform create a plan, which we can review:
```bash
terraform plan -out dockernodes.tfplan
```
* Now we execute exactly this plan:
```bash
terraform apply dockernodes.tfplan
```

## Provision kubernetes with rke

### Generate RKE-Config

You can generate the config maually with this command:
```bash
rke config
```

It asks you for all required values, please fill in the IP-Addresses of the created dockernodes.

To generate it automatically, you can use the python-script [create_config.py](./rke-demo/create_config.py), which takes the IP-Addresses from the terraform-output and injects it into the cluster-template.

### Deploy Kubernetes

After `cluster.yml` is generated, just enter
```bash
rke up
```

The Kubernetes-Cluster will be build in a few minutes, and a `.kube_config_cluster.yml` is saved to your working directory.

To test the success, you can execute for example
```bash
kubectl --kubeconfig .kube_config_cluster.yml get all --all-namespaces
```

## ToDo's

* Use Private Network IP's for kubernetes componentes (internal_address)
* Setup a Digital Ocean Loadbalancer
  * https://github.com/digitalocean/digitalocean-cloud-controller-manager
  * https://thenewstack.io/tutorial-run-multi-node-kubernetes-cluster-digitalocean/
* Add more security
* Use different terraform resources for controlplane/etcd and worker
* Generate rke config with terraform
* Use calico network
* Validate installation with serverspec or goss
  * https://github.com/aelsabbahy/goss
  * https://medium.com/@aelsabbahy/docker-1-12-kubernetes-simplified-health-checks-and-container-ordering-with-goss-fa8debbe676c
  * http://serverspec.org/
  * http://www.infrabricks.de/blog/2014/09/10/docker-container-mit-serverspec-testen/
  * http://www.infrabricks.de/blog/2015/04/16/docker-container-mit-serverspetesten-teil-2/
* Check update new rancher release
* Add terraform KVM Setup
* Add architecture design picture

## Links

* https://medium.com/@kenfdev/deploying-kubernetes-on-premise-with-rke-and-deploying-openfaas-on-it-part-1-69a35ddfa507
* https://github.com/rancher/rke
* https://schd.ws/hosted_files/kccncna17/d8/Hacking%20and%20Hardening%20Kubernetes%20By%20Example%20v2.pdf	
* https://github.com/garethr/kubetest
* https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean

