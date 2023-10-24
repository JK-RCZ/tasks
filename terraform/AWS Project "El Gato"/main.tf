


module "dev-environment-net" {
  source = "../modules/AWS.net.sub.nat.igw"
  vpc_parameters = {
    region = var.vpc_parameters.region
    vpc_cidr_block = var.vpc_parameters.vpc_cidr_block
    vpc_name_tag = var.vpc_parameters.vpc_name_tag
    internnet_gw_name_tag = var.vpc_parameters.internnet_gw_name_tag
  }
  common_tags = var.common_tags
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  
}

data "aws_subnet" "subnet" {
  
  tags = {
    Name = var.subnet_name
  }
  depends_on = [ module.dev-environment-net ]
 
}

data "aws_vpc" "vpc" {
  
  tags = {
    Name = var.vpc_name
  }
  depends_on = [ module.dev-environment-net ]
 
}

module "dev-environment-instance" {
  source = "../modules/AWS.ec2"
  common_tags = var.common_tags
  ssh_key = var.ssh_key
  security_group = var.security_group
  aws_instance = var.aws_instance
  subnet_id = data.aws_subnet.subnet.id
  vpc_id = data.aws_vpc.vpc.id
}
