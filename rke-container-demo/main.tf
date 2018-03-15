provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "cluster_key" {
  name       = "Terraform RKE Cluster Key"
  public_key = "${file(var.ssh_cluster_public_key)}"
}

resource "digitalocean_droplet" "controlplane" {
    count = "${var.controlplane_count}"
    image = "ubuntu-16-04-x64"
    name = "controlplane-${count.index}"
    region = "${var.do_region}"
    size = "${var.controlplane_size}"
    private_networking = true
    ssh_keys = ["${digitalocean_ssh_key.cluster_key.fingerprint}"]

  connection {
      user = "root"
      type = "ssh"
      private_key = "${file(var.ssh_cluster_private_key)}"
      timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      # install recommended docker version
      "curl https://releases.rancher.com/install-docker/17.03.sh | sh"
    ]
  }

}

resource "digitalocean_droplet" "worker" {
    count = "${var.worker_count}"
    image = "ubuntu-16-04-x64"
    name = "worker-${count.index}"
    region = "${var.do_region}"
    size = "${var.worker_size}"
    private_networking = true
    ssh_keys = ["${digitalocean_ssh_key.cluster_key.fingerprint}"]

    connection {
        user = "root"
        type = "ssh"
        private_key = "${file(var.ssh_cluster_private_key)}"
        timeout = "2m"
    }

  provisioner "remote-exec" {
    inline = [
      # install recommended docker version
      "curl https://releases.rancher.com/install-docker/17.03.sh | sh"
    ]
  }

}


