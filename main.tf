# AWS Provider
provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}

# OpenShift Module
module "openshift" {
  source            = "./modules/openshift"
  aws_region        = "${var.aws_region}"
  local_domain_name = "${var.local_domain_name}"
  username          = "${var.username}"
  public_key_path   = "${var.public_key_path}"
  vpc_cidr          = "${var.vpc_cidr}"
  subnet_cidr       = "${var.subnet_cidr}"
  instance_types    = "${var.instance_types}"
}

# Outputs
output "bastion-public-dns" {
  value = "${module.openshift.bastion-public-dns}"
}

output "master-public-ip" {
  value = "${module.openshift.master-public-ip}"
}

output "master-public-dns" {
  value = "${module.openshift.master-public-dns}"
}

output "worker1-public-dns" {
  value = "${module.openshift.worker1-public-dns}"
}

output "worker2-public-dns" {
  value = "${module.openshift.worker2-public-dns}"
}
