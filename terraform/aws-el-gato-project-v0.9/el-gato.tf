module "vpc" {
  source                  = "../modules/aws-vpc"
  vpc                     = {
    region                = var.vpc.region
    tenancy               = var.vpc.tenancy
    cidr_block            = var.vpc.cidr_block
    name                  = var.vpc.name
    }
  common_tags             = var.common_tags
}

data "aws_vpc" "vpc" {
  
  tags                    = {
    Name                  = var.vpc.name
  }
  depends_on              = [ module.vpc ]
 
}

module "subnets" {
  source                  = "../modules/aws-subnet"
  subnets                 = var.subnets
  vpc_id                  = data.aws_vpc.vpc.id
  common_tags             = var.common_tags
  
}

module "igw" {
  source                  = "../modules/aws-internet-gateway"
  vpc_id                  = data.aws_vpc.vpc.id
  igw_name                = var.igw_name
  common_tags             = var.common_tags
}

module "nat" {
  source                  = "../modules/aws-nat"
  nat                     = var.nat
  common_tags             = var.common_tags
  depends_on              = [ module.subnets ]
}

module "public_root_table" {
  source                  = "../modules/aws-route-table-igw"
  igw_route_table_params  = var.igw_route_table_params
  vpc_id                  = data.aws_vpc.vpc.id
  common_tags             = var.common_tags
  depends_on              = [ module.subnets, module.igw ]
}

module "private_root_table" {
  source                  = "../modules/aws-route-table-nat"
  nat_route_table_params  = var.nat_route_table_params
  vpc_id                  = data.aws_vpc.vpc.id
  common_tags             = var.common_tags
  depends_on              = [ module.subnets, module.nat ]
}

module "ec2_1" {
  source                  = "../modules/aws-ec2-instance"
  ec2                     = var.ec2
  common_tags             = var.common_tags  
  public_key_contents     = var.public_key_contents
  depends_on              = [ module.vpc, module.subnets ]
}

module "load_balancer" {
  source                  = "../modules/aws-load-balancer"
  load_balancer           = var.load_balancer
  common_tags             = var.common_tags
  depends_on              = [ module.ec2_1, module.subnets ]
}

module "target_group" {
  source                  = "../modules/aws-target-group"
  target_group            = var.target_group
  common_tags             = var.common_tags
  depends_on = [ module.vpc, module.ec2_1, module.load_balancer ]
}