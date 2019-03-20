#### Idenity & Access Management ####
## Master Node Role
# resource "aws_iam_role" "master" {
#   name        = "${var.username}-ocp-master-role"
#   description = "OCP Master Node"
#
#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "sts:AssumeRole",
#             "Principal": {
#                 "Service": "ec2.amazonaws.com"
#             }
#         }
#     ]
# }
# EOF
# }
## Worker Node Role
# resource "aws_iam_role" "worker" {
#   name        = "${var.username}-ocp-worker-role"
#   description = "OCP Worker Node"
#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "sts:AssumeRole",
#             "Principal": {
#                 "Service": "ec2.amazonaws.com"
#             }
#         }
#     ]
# }
# EOF
# }
## Master Node Policy
# resource "aws_iam_policy" "master" {
#   name        = "${var.username}-ocp-master-policy"
#   path        = "/"
#   description = "OCP Master Node"
#
#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "sts:AssumeRole",
#             "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.username}-ocp-*"
#         }
#     ]
# }
# EOF
# }
## Worker Node Policy
# resource "aws_iam_policy" "worker" {
#   name        = "${var.username}-ocp-worker-policy"
#   description = "OCP Worker Node"
#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "sts:AssumeRole",
#             "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.username}-ocp-*"
#         }
#     ]
# }
# EOF
# }
## Master Policy Attachment
# resource "aws_iam_role_policy_attachment" "master" {
#   role       = "${aws_iam_role.master.name}"
#   policy_arn = "${aws_iam_policy.master.arn}"
# }
## Worker Policy Attachment
# resource "aws_iam_role_policy_attachment" "worker" {
#   role       = "${aws_iam_role.worker.name}"
#   policy_arn = "${aws_iam_policy.worker.arn}"
# }
## Master Instance Profile
# resource "aws_iam_instance_profile" "master" {
#   name  = "${var.username}-ocp-master-instance-profile"
#   roles = ["${aws_iam_role.master.name}"]
# }
## Worker Instance Profile
# resource "aws_iam_instance_profile" "worker" {
#   name = "${var.username}-ocp-worker-instance-profile"
#   role = "${aws_iam_role.worker.name}"
# }
## Kube2IAM Roles
# S3 Read
# resource "aws_iam_role" "s3read" {
#   name        = "${var.username}-kube2iam-s3read-role"
#   description = "Kube2IAM S3 Read Role"
#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "sts:AssumeRole",
#             "Principal": {
#                 "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.username}-ocp-worker-role"
#             }
#         }
#     ]
# }
# EOF
# }
## Kube2IAM Policies
# S3 Read
# resource "aws_iam_policy" "s3read" {
#   name        = "${var.username}-kube2iam-s3read-policy"
#   description = "Kube2IAM S3 Read Role"
#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "s3:GetObject",
#             "Resource": "arn:aws:s3:::dev-act-on-${var.username}-ocp/*"
#         }
#     ]
# }
# EOF
# }
## Kube2IAM Policy Attachment
# S3 Read
# resource "aws_iam_role_policy_attachment" "s3read" {
#   role       = "${aws_iam_role.s3read.name}"
#   policy_arn = "${aws_iam_policy.s3read.arn}"
# }

