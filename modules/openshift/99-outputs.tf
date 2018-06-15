#### Outputs ####

output "bastion-public-dns" {
  value = "${aws_instance.bastion.public_dns}"
}

output "master-public-ip" {
  value = "${aws_instance.master.public_ip}"
}

output "master-public-dns" {
  value = "${aws_instance.master.public_dns}"
}

output "worker1-public-dns" {
  value = "${aws_instance.worker1.public_dns}"
}

output "worker2-public-dns" {
  value = "${aws_instance.worker2.public_dns}"
}
