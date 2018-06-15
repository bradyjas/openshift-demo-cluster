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

# # Private Hosted REVERSE DNS Zone
# resource "aws_route53_zone" "ocp_private_reverse" {
#   name    = "${var.local_domain_name}"
#   comment = "Private DNS zone for ${var.username}-ocp-vpc"
#   vpc_id  = "${aws_vpc.ocp.id}"


#   tags = "${merge(
#     local.common_tags,
#     map(
#       "Name", "${var.username}-ocp-dns"
#     )
#   )}"
# }


# # Private REVERSE DNS Records
# resource "aws_route53_record" "master_reverse" {
#   zone_id = "${aws_route53_zone.ocp_private.zone_id}"
#   name    = "master"
#   type    = "A"
#   ttl     = 300
#   records = ["${aws_instance.master.private_ip}"]
# }


# resource "aws_route53_record" "worker1_reverse" {
#   zone_id = "${aws_route53_zone.ocp_private.zone_id}"
#   name    = "worker1"
#   type    = "A"
#   ttl     = 300
#   records = ["${aws_instance.worker1.private_ip}"]
# }


# resource "aws_route53_record" "worker2_reverse" {
#   zone_id = "${aws_route53_zone.ocp_private.zone_id}"
#   name    = "worker2"
#   type    = "A"
#   ttl     = 300
#   records = ["${aws_instance.worker2.private_ip}"]
# }

