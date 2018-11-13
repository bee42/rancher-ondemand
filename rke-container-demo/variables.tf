variable "do_token" {}
variable "do_region" {
    default="fra1"
}
variable "ssh_cluster_public_key" {
    description="Path to SSH Public Key"
}
variable "ssh_cluster_private_key" {
    description="Path to SSH Private Key"
}
variable "controlplane_count" {
    description="Describes the amount of controlplanes for the clusters"
    default=1
}
variable "worker_count" {
    description="Describes the amount of worker for the clusters"
    default=2
}
variable "worker_size" {
    default="8gb"
}
variable "controlplane_size" {
    default="4gb"
}
