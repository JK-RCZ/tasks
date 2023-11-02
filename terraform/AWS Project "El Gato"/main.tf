locals {
  pub_subs = [
    for i in var.public_subnets_ids:
      data.aws_subnet.public_subnets[i].id 
  ]
  priv_subs = [
    for i in var.private_subnets_ids:
      data.aws_subnet.private_subnets[i].id 
  ]
}

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

data "aws_subnet" "public_subnets" {
  for_each = toset(var.public_subnets_ids)
  tags = {
    
    Name = each.key
  }
  
  depends_on = [ module.dev-environment-net ]
 
}

data "aws_vpc" "vpc" {
  
  tags = {
    Name = var.vpc_name
  }
  depends_on = [ module.dev-environment-net ]
 
}

data "aws_subnet" "private_subnets" {
  for_each = toset(var.private_subnets_ids)
  tags = {
    
    Name = each.key
  }
  
  depends_on = [ module.dev-environment-net ]
 
}

#data "aws_secur" "secur" {
#
#  tags = {
#    Name = var.common_tags.Owner
#  }
#  
#}

data "aws_rds" "name" {
  
}

#data "aws_rds_orderable_db_instance" "rds-list" {
#  engine = var.rds_instance.engine
#  instance_class = var.rds_instance.instance_class
#  engine_version = var.rds_instance.engine_version
#  storage_type = var.rds_instance.storage_type
#}



module "dev-environment-instance" {
  source = "../modules/AWS.ec2"
  common_tags = var.common_tags
  public-key = var.public_key
  security_group = var.security_group
  aws_instance = var.aws_instance
  subnet_id = data.aws_subnet.subnet.id
  vpc_id = data.aws_vpc.vpc.id
  public_subnets_ids = local.pub_subs
  rds_instance = var.rds_instance
  db-parameter-group = var.db-parameter-group
  subnet_ids = local.priv_subs
  #vpc_security_group_ids = data.aws_security_groups.secur.id
}
