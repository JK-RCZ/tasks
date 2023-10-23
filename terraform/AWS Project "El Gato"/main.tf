


module "dev-environment" {
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
  ssh_key = var.ssh_key
  security_group = var.security_group
  aws_instance = var.aws_instance
}

  
