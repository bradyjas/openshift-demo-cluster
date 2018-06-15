# openshift-demo-cluster

## **WORK IN PROGRESS**

This demo Terraform and Ansible package will build a multi-node OpenShift
Origin environment in AWS. Mostly for my own practice with Terraform, Ansible,
OpenShift and proof-of-concept. I plan to abstract as much as I can. Ultimate
goal would be for this package to be usable on other cloud platforms with
little change.


## Expected Features

### Terraform
- VPC creation
- Internet gateway
- Subnets
- Routes
- Security groups
- EC2 instances
  - One Master node
  - Two Worker nodes
- AMIs (CentOS 7)

### Ansible
- OpenShift installed via Ansible
  - One Master node in "Infra" mode (router and Docker repo)
  - Two Worker nodes to run applications


## Future Features
- DNS zone creation
  - Public and private zones
- Let's Encrypt certificate integration
  - OpenShift to be install via Ansible playbooks
- Elastic Load Balancers for OpenShift masters and nodes
- Auto Scale Groups for OpenShift masters, etcd instances, and nodes
  - Scaling events handled by CloudWatch/Lambda/Ansible functions
- IPv6
