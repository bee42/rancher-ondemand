# If you intened to deploy Kubernetes in an air-gapped envrionment,
# please consult the documentation on how to configure custom RKE images.
nodes:
${controlplane}
${worker}
network:
  plugin: calico
  options: {}
dns:
    provider: coredns
authorization:
    mode: rbac
auth:
  strategy: x509
  options: {}
addons: ""
ssh_key_path: ${ssh_key_path}
