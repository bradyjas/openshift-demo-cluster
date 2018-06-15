### DNS (Route 53) ###

# Private Hosted DNS Zone
resource "aws_route53_zone" "ocp_private" {
  name    = "${var.local_domain_name}"
  comment = "Private DNS zone for ${var.username}-ocp-vpc"
  vpc_id  = "${aws_vpc.ocp.id}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-dns"
    )
  )}"
}

# Private DNS Records
# resource "aws_route53_record" "bastion" {
#   zone_id = "${aws_route53_zone.ocp_private.zone_id}"
#   name    = "bastion"
#   type    = "A"
#   ttl     = 300
#   records = ["${aws_instance.bastion.private_ip}"]
# }

resource "aws_route53_record" "master" {
  zone_id = "${aws_route53_zone.ocp_private.zone_id}"
  name    = "master"
  type    = "A"
  ttl     = 300
  records = ["${aws_instance.master.private_ip}"]
}

resource "aws_route53_record" "worker1" {
  zone_id = "${aws_route53_zone.ocp_private.zone_id}"
  name    = "worker1"
  type    = "A"
  ttl     = 300
  records = ["${aws_instance.worker1.private_ip}"]
}

resource "aws_route53_record" "worker2" {
  zone_id = "${aws_route53_zone.ocp_private.zone_id}"
  name    = "worker2"
  type    = "A"
  ttl     = 300
  records = ["${aws_instance.worker2.private_ip}"]
}

# Private Hosted REVERSE DNS Zone
resource "aws_route53_zone" "ocp_private_reverse" {
  comment = "Private reverse DNS zone for ${var.username}-ocp-vpc"
  vpc_id  = "${aws_vpc.ocp.id}"

  name = "${format("%s.%s.%s.in-addr.arpa.",
      element( split(".", var.subnet_cidr) ,2),
      element( split(".", var.subnet_cidr) ,1),
      element( split(".", var.subnet_cidr) ,0),
    )
  }"
}

# Private REVERSE DNS Records
resource "aws_route53_record" "master_reverse" {
  zone_id = "${aws_route53_zone.ocp_private_reverse.zone_id}"
  name    = "${element( split(".", aws_instance.master.private_ip) ,3)}"
  type    = "PTR"
  ttl     = 300
  records = ["master.${var.local_domain_name}"]
}

resource "aws_route53_record" "worker1_reverse" {
  zone_id = "${aws_route53_zone.ocp_private_reverse.zone_id}"
  name    = "${element( split(".", aws_instance.worker1.private_ip) ,3)}"
  type    = "PTR"
  ttl     = 300
  records = ["worker1.${var.local_domain_name}"]
}

resource "aws_route53_record" "worker2_reverse" {
  zone_id = "${aws_route53_zone.ocp_private_reverse.zone_id}"
  name    = "${element( split(".", aws_instance.worker2.private_ip) ,3)}"
  type    = "PTR"
  ttl     = 300
  records = ["worker2.${var.local_domain_name}"]
}
