# If you intened to deploy Kubernetes in an air-gapped envrionment,
# please consult the documentation on how to configure custom RKE images.
nodes:
${controlplane}
${worker}
services:
  etcd:
    image: rancher/coreos-etcd:v3.0.17
    extra_args: {}
  kube-api:
    image: rancher/k8s:v1.8.7-rancher1-1
    extra_args: {}
    service_cluster_ip_range: 10.233.0.0/18
  kube-controller:
    image: rancher/k8s:v1.8.7-rancher1-1
    extra_args: {}
    cluster_cidr: 10.233.64.0/18
    service_cluster_ip_range: 10.233.0.0/18
  scheduler:
    image: rancher/k8s:v1.8.7-rancher1-1
    extra_args: {}
  kubelet:
    image: rancher/k8s:v1.8.7-rancher1-1
    extra_args: {}
    cluster_domain: cluster.local
    infra_container_image: rancher/pause-amd64:3.0
    cluster_dns_server: 10.233.0.3
  kubeproxy:
    image: rancher/k8s:v1.8.7-rancher1-1
    extra_args: {}
network:
  plugin: flannel
  options: {}
auth:
  strategy: x509
  options: {}
addons: ""
system_images: {}
ssh_key_path: ${ssh_key_path}
