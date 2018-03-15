data "template_file" "controlplane" {
  template = "${file("${path.module}/template/controlplane.tpl")}"
  count= "${var.controlplane_count}"
  vars {
    controlplane_address = "${element(digitalocean_droplet.controlplane.*.ipv4_address,count.index)}"
  }
}

data "template_file" "worker" {
  template = "${file("${path.module}/template/worker.tpl")}"
  count= "${var.worker_count}"
  vars {
    worker_address = "${element(digitalocean_droplet.worker.*.ipv4_address,count.index)}"
  }
}

data "template_file" "cluster" {
  template = "${file("${path.module}/template/cluster.tpl")}"
  vars {
    controlplane = "${join("\n",data.template_file.controlplane.*.rendered)}"
    worker = "${join("\n",data.template_file.worker.*.rendered)}"
    ssh_key_path ="${var.ssh_cluster_private_key}"
  }
}

output "worker_template" {
    value="${data.template_file.worker.*.rendered}"   
}
output "controlplane_template" {
    value="${data.template_file.controlplane.*.rendered}" 
}
output "cluster_template" {
    value="${data.template_file.cluster.*.rendered}"
}

