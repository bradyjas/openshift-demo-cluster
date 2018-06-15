variable "aws_profile" {
  description = "AWSCLI profile to use for provision (Example: terraform)"
}

variable "aws_region" {
  description = "The AWS region to deploy into (Example: us-west-2)"
  default     = "us-west-2"
}

variable "local_domain_name" {
  description = "Local domain name to use for DNS (Example: ocp.local)"
  default     = "ocp.local"
}

variable "public_key_path" {
  description = "Local path to your public SHA256 key (Example: ~/.ssh/aws-username.pub)"
}

variable "username" {
  description = "Your username (first initial + last name) to identify the created objects (Example: jbrady)"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (Example: 10.10.0.0/28)"
  default     = "10.10.0.0/28"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet (Example: 10.10.0.0/28)"
  default     = "10.10.0.0/28"
}

variable "instance_types" {
  description = "EC2 instance types for the provisioned instances (Example: t2.medium)"
  type        = "map"

  default = {
    bastion = "t2.small"
    master  = "t2.medium"
    worker  = "t2.medium"
  }
}
