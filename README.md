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
- exceute quickstart.sh


## Prerequisites
### Terraform by HashiCorp

With terraform, we can write our infrastructure as code. If you don't already have terraform installed, please have a quick look at https://www.terraform.io/intro/getting-started/install.html

### Rancher Kubernetes Engine (RKE)
Get it from https://github.com/rancher/rke, where you can download the binary for your architecture.
Please rename it to rke and make it available by setting the PATH-Variable of your environment.


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
Terraform needs some parameters to securely communicate with your Digtal Ocean Account. There are different ways to do this, here we pass them as environment-variables:

    export TF_VAR_do_token=YOUR_DIGITALOCEAN_ACCESS_TOKEN
    export TF_VAR_pvt_key=$HOME/.ssh/id_rsa
    export TF_VAR_pub_key=${TF_VAR_pvt_key}.pub
    export TF_VAR_ssh_fingerprint=`ssh-keygen -E md5 -lf ${TF_VAR_pub_key} | awk '{print $2}' | sed 's/^MD5://g'`


__Example__: set-tf-env-example.sh

You have to replace the values according to your environment. If the one-liner to generate the MD5-fingerprint does not work for you (only tested on Ubuntu 16.04), you should simply use your MD5-fingerprint from the notes you've taken before.  :)

Now we create some files for terraform to describe our desired infrastructure.

First we need an provisioner to tell terraform which cloud we connect to:

__Example__: provisioner.tf

Then we create a file describing our three docker-nodes, on which the Kubernetes-Cluster will be installed later.
* resource: Name, Baseimage (here: Ubuntu 16.04), RAM, Region etc.
* connection: How can terraform connect to the created droplet
* provision: Which commands should be executed, e.g. to install docker 

__Example__: dockernodes.tf

Next we have to initialize terraform simply with
> terraform init

To verify that all files are syntactically correct, please excute
> terraform validate

## Create infrastructure
* We let terraform create a plan, which we can review:
> terraform plan -out dockernodes.tfplan

* Now we execute eexactly this plan:
> terraform apply dockernodes.tfplan

# Generate RKE-Config
You can generate the config maually with this command:
> rke config

It asks you for all required values, please fill in the IP-Addresses of the created dockernodes.

To generate it automatically, you can use the python-script **create_config.py**, which takes the IP-Addresses from the terraform-output and injects it into the cluster-template.

# Deploy Kubernetes
After **cluster.yml** is generated, just enter
> rke up

The Kubernetes-Cluster will be build in a few minutes, and a .kube_config_cluster.yml is saved to your working directory.

To test the success, you can execute for example
> kubectl --kubeconfig .kube_config_cluster.yml get all --all-namespaces


## Links

* https://medium.com/@kenfdev/deploying-kubernetes-on-premise-with-rke-and-deploying-openfaas-on-it-part-1-69a35ddfa507
* https://github.com/rancher/rke
* https://schd.ws/hosted_files/kccncna17/d8/Hacking%20and%20Hardening%20Kubernetes%20By%20Example%20v2.pdf	
* https://github.com/garethr/kubetest
* https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean

