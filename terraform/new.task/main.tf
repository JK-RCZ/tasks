


module "dev-environment" {
  source = "../modules/net.sub.nat.igw"
  vpc_parameters = {
    region = var.vpc_parameters.region
    vpc_cidr_block = var.vpc_parameters.vpc_cidr_block
    vpc_name_tag = var.vpc_parameters.vpc_name_tag
  }
  common_tags = var.common_tags
  subnets = var.subnets
}

  
