# This module asks for PUBLIC KEY. 
# Do not describe public_key_contents variable in tfvars file, so you can enter it safely either on prompt after terraform plan/apply command or 
# add it to terraform enviroment variable before the launch by command: export TF_VAR_public_key_contents='your public key'

#This module depends on VPC and subnets, please set respective dependensies in root module

resource "aws_key_pair" "ein" {
  key_name                    = var.ec2.public_key_name
  public_key                  = var.public_key_contents

  tags                        = merge(var.common_tags, {Name = "${var.ec2.public_key_name}"})
}

data "aws_vpc" "net" {
    tags                      = {
      Name                    = var.ec2.vpc_name
    }
  
}

resource "aws_security_group" "zwei" {
  vpc_id                      = data.aws_vpc.net.id
    
  dynamic "ingress" {
    for_each                  = toset(var.ec2.security_group_parameters.inbound_ports_to_open)
    content {
      from_port               = ingress.value
      to_port                 = ingress.value
      protocol                = "tcp"
      cidr_blocks             = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["0.0.0.0/0"]
  }

  tags                        = merge(var.common_tags, {Name = "${var.ec2.security_group_parameters.sg_name}"})
}

data "aws_subnet" "subnet" {
    tags                      = {
      Name                    = var.ec2.instance_parameters.subnet_name
    }
}

resource "aws_instance" "drei" {
  
  ami                         = var.ec2.instance_parameters.instance_ami
  instance_type               = var.ec2.instance_parameters.instance_type
  subnet_id                   = data.aws_subnet.subnet.id
  associate_public_ip_address = var.ec2.instance_parameters.associate_public_ip_address
  vpc_security_group_ids      = [aws_security_group.zwei.id]
  key_name                    = aws_key_pair.ein.key_name
  user_data                   = "${file(var.ec2.instance_parameters.user_data_path)}"

  tags                        = merge(var.common_tags, {Name = "${var.ec2.instance_parameters.instance_name}"})
}