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


## Starting a Cluster

1. Create a `terraform.tfvars` file container your specific environment
   details. Here's an example:

```
aws_profile = "aws-dev"
aws_region = "us-west-1"
local_domain_name = "ocp.local"
username = "jdoe"
public_key_path = "~/.ssh/aws-jdoe.pub"
vpc_cidr = "10.10.0.0/28"
subnet_cidr = "10.10.0.0/28"
instance_types = {
  master  = "t2.medium"
  worker  = "t2.medium"
}
```

2. Create a new EC2 KeyPair. You may also use an existing KeyPair and skip this
   step.

```bash
ssh-keygen -t rsa -b 2048 -C "aws-<your username>-ocp" -f <path to create private key>
```

3. Plan and apply the Terraform actions.

```bash
# Plan the actions
terraform plan -out planfile

# Analyse the plan results. If all looks good, apply:
terraform apply planfile
```

4. Prepare the nodes

```bash
# Set a few variables
master=<public ip/name of master>
privkey=<path to your new KeyPair private key>
repourl=<URL of this repo>

# Copy your private key to the master node
scp -i ${privkey} ${privkey} centos@${master}:~/.ssh/$(basename ${privkey})
```

5. Checkout and run the Ansible installation playbooks.

```bash
# SSH into the master node
ssh -i ${privkey} centos@${master}

# Clone this and the OpenShift-Ansible repos
git clone --depth 1 ${repourl} ~/openshift-demo-cluster
git clone --depth 1 -b release-3.9 https://github.com/openshift/openshift-ansible.git ~/openshift-ansible
cd ~/openshift-demo-cluster

# Take a look at the inventory and make and changes needed
vi inventory.ini

# Run the prepare playbook
ansible-playbook -i inventory.ini prepare.yml --key-file ${privkey}

# Run the OpenShift-Ansible playbooks
ansible-playbook -i inventory.ini ~/openshift-ansible/playbooks/pre --key-file ${privkey}
ansible-playbook -c paramiko -i inventory.ini ~/openshift-ansible/playbooks/prerequisites.yml --key-file <private key>
ansible-playbook -c paramiko -i inventory.ini ~/openshift-ansible/playbooks/deploy_cluster.yml --key-file <private key>
```

6. Add users to the `htpasswd` file

```bash
htpasswd -b /etc/origin/master/htpasswd developer developer
oc adm policy add-cluster-role-to-user cluster-admin developer
systemctl restart origin-master-api
```
