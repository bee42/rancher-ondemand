resource "digitalocean_droplet" "dockernodes" {
    count = 3
    image = "ubuntu-16-04-x64"
    name = "dockernode-${count.index}"
    region = "nyc1"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

  connection {
      user = "root"
      type = "ssh"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      # install recommended docker version
      "curl https://releases.rancher.com/install-docker/17.03.sh | sh"
    ]
  }

}

output "public_ips" {
  value = ["${digitalocean_droplet.dockernodes.*.ipv4_address}"]
}

