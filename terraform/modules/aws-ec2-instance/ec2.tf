# This module asks for PUBLIC KEY. 
# Do not describe public_key_contents variable in tfvars file, so you can enter it safely either on prompt after terraform plan/apply command or 
# add it to terraform enviroment variable before the launch by command: export TF_VAR_public_key_contents='your public key'

# This module depends on subnets and security groups.
# Please set respective dependensies in root module!


data "aws_subnet" "data" {
    tags                      = {
      Name                    = var.ec2.instance_parameters.subnet_name
    }
}

data "aws_security_group" "data" {
  for_each = toset(var.ec2.instance_parameters.security_group_names)
  tags = {
    Name = each.key
  }
}

resource "aws_key_pair" "ein" {
  key_name                    = var.ec2.public_key_name
  public_key                  = var.public_key_contents

  tags                        = merge(var.common_tags, {Name = "${var.ec2.public_key_name}"})
}

resource "aws_instance" "zwei" {
  
  ami                         = var.ec2.instance_parameters.instance_ami
  instance_type               = var.ec2.instance_parameters.instance_type
  subnet_id                   = data.aws_subnet.data.id
  associate_public_ip_address = var.ec2.instance_parameters.associate_public_ip_address
  vpc_security_group_ids      = local.sg_ids
  key_name                    = aws_key_pair.ein.key_name
  user_data                   = "${file(var.ec2.instance_parameters.user_data_path)}"

  tags                        = merge(var.common_tags, {Name = "${var.ec2.instance_parameters.instance_name}"})
}