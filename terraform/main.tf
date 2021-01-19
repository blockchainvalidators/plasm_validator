# Builds a new VPC along with associated secuirty groups
# and the EC2 instance

variable "private_key" {
  default = "OTN"
}

variable "private_user" {
  default = "ubuntu"
}

variable "project_name" {
  default = "Plasm-Validator"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_subnets" {
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

provider "aws" {
  region = "us-east-1"
  profile = "terraform-operator"
}

data "aws_availability_zones" "available" {
  
}

data "aws_ami" "image" {
  most_recent = true
  owners = ["self"]
  filter {                       
    name = "tag:Validator"     
    values = ["${var.project_name}"]
  }                              
}

output "ami_id" {
  value = data.aws_ami.image.id
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"
  name = "vpc-${var.project_name}"
  cidr = var.vpc_cidr
  azs = data.aws_availability_zones.available.names
  public_subnets = var.vpc_subnets

  enable_dns_support = true
  enable_dns_hostnames = true

}

module "ssh_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "~> 3.0"
  name = "ssh"
  description = "Provides ssh access to the instance"
  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["http-80-tcp", "https-443-tcp", "all-icmp"]
  egress_rules = ["all-all"]

  # omitted...
}

module "ec2_nstance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name = var.project_name
  instance_count = 1

  ami = data.aws_ami.image.id
  instance_type = "t3.micro"
  key_name = var.private_key
  monitoring = true
  vpc_security_group_ids = [module.ssh_security_group.this_security_group_id]
  subnet_id = module.vpc.public_subnets[0]
  root_block_device = [{
    ipos = 150
    volume_size = 100
    volume_type = "gp2"
  }
  ]
  user_data = file("user_data.sh")
  tags = {
    Terraform = "true"
    Project = "${var.project_name}"
  }
}