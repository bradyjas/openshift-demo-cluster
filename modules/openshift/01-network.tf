#### Networking ####

# VPC
resource "aws_vpc" "ocp" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-vpc"
    )
  )}"
}

# DHCP Options
resource "aws_vpc_dhcp_options" "ocp" {
  domain_name         = "${var.local_domain_name}"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-dopt"
    )
  )}"
}

# DHCP Options Association
resource "aws_vpc_dhcp_options_association" "ocp" {
  vpc_id          = "${aws_vpc.ocp.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.ocp.id}"
}

# Internet Gateway
resource "aws_internet_gateway" "ocp" {
  vpc_id = "${aws_vpc.ocp.id}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-igw"
    )
  )}"
}

# Subnet
resource "aws_subnet" "ocp" {
  vpc_id                  = "${aws_vpc.ocp.id}"
  cidr_block              = "${var.subnet_cidr}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-subnet"
    )
  )}"
}

# Network ACL
resource "aws_network_acl" "ocp" {
  vpc_id     = "${aws_vpc.ocp.id}"
  subnet_ids = ["${aws_subnet.ocp.id}"]

  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    rule_no    = 100
    action     = "allow"
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    rule_no    = 100
    action     = "allow"
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-acl"
    )
  )}"
}

# Route Table
resource "aws_route_table" "ocp" {
  vpc_id = "${aws_vpc.ocp.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ocp.id}"
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.username}-ocp-rtb"
    )
  )}"
}

# Route Table Associations
resource "aws_route_table_association" "ocp" {
  subnet_id      = "${aws_subnet.ocp.id}"
  route_table_id = "${aws_route_table.ocp.id}"
}
