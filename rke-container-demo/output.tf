output "controlplane_public_ips" {
  value = ["${digitalocean_droplet.controlplane.*.ipv4_address}"]
}

output "worker_public_ips" {
  value = ["${digitalocean_droplet.worker.*.ipv4_address}"]
}

output "ssh_private_key" {
    value = "${file(var.ssh_cluster_private_key)}"
}

output "ssh_public_key" {
    value = "${file(var.ssh_cluster_public_key)}"
}
