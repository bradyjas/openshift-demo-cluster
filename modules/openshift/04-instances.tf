#### EC2 Instances ####

# Key Pair
resource "aws_key_pair" "ocp" {
  key_name   = "aws-${var.username}"
  public_key = "${file(var.public_key_path)}"
}

## Instances

# Master
resource "aws_instance" "master" {
  ami               = "${data.aws_ami.centos7.id}"
  instance_type     = "${var.instance_types["master"]}"
  key_name          = "${aws_key_pair.ocp.key_name}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  subnet_id         = "${aws_subnet.ocp.id}"

  #iam_instance_profile   = "${aws_iam_instance_profile.master.name}"
  vpc_security_group_ids = ["${aws_security_group.master.id}"]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = 50
    volume_type = "gp2"
  }

  user_data = <<-EOF
    #cloud-config
    hostname: master
    fqdn: master.${var.local_domain_name}
    runcmd:
    - [ yum, install, -y, epel-release ]
    - [ yum, update, -y ]
    - [ yum, install, -y , git, ansible, tmux, kernel-devel-$(uname -r) ]
  EOF

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-master"
    )
  )}"

  volume_tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-master"
    )
  )}"
}

# Elastic IP for Master
# resource "aws_eip" "master" {
#   vpc        = true
#   instance   = "${aws_instance.master.id}"
#   depends_on = ["aws_internet_gateway.ocp"]

#   tags = "${merge(
#     local.common_tags,
#     map(
#       "Name", "${var.username}-ocp-eip"
#     )
#   )}"
# }

# Use already existing Elastic IP for Master
resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.master.id}"
  allocation_id = "eipalloc-9c4c03a0"
}

# Worker 1
resource "aws_instance" "worker1" {
  ami               = "${data.aws_ami.centos7.id}"
  instance_type     = "${var.instance_types["worker"]}"
  key_name          = "${aws_key_pair.ocp.key_name}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  subnet_id         = "${aws_subnet.ocp.id}"

  # iam_instance_profile        = "${aws_iam_instance_profile.worker.name}"
  vpc_security_group_ids      = ["${aws_security_group.worker.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = 50
    volume_type = "gp2"
  }

  user_data = <<-EOF
    #cloud-config
    hostname: worker1
    fqdn: worker1.${var.local_domain_name}
  EOF

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-worker1"
    )
  )}"

  volume_tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-worker1"
    )
  )}"
}

# Worker 2
resource "aws_instance" "worker2" {
  ami               = "${data.aws_ami.centos7.id}"
  instance_type     = "${var.instance_types["worker"]}"
  key_name          = "${aws_key_pair.ocp.key_name}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  subnet_id         = "${aws_subnet.ocp.id}"

  # iam_instance_profile        = "${aws_iam_instance_profile.worker.name}"
  vpc_security_group_ids      = ["${aws_security_group.worker.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = 50
    volume_type = "gp2"
  }

  user_data = <<-EOF
    #cloud-config
    hostname: worker2
    fqdn: worker2.${var.local_domain_name}
  EOF

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-worker2"
    )
  )}"

  volume_tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-worker2"
    )
  )}"
}
