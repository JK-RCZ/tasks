module "vpc" {
  source                                = "../modules/aws-vpc"
  vpc                                   = {
    region                              = var.vpc.region
    tenancy                             = var.vpc.tenancy
    cidr_block                          = var.vpc.cidr_block
    name                                = var.vpc.name
    }
  common_tags                           = var.common_tags
}

module "subnets" {
  source                                = "../modules/aws-subnet"
  subnets                               = var.subnets
  common_tags                           = var.common_tags
  depends_on                            = [ module.vpc ]
}

module "igw" {
  source                                = "../modules/aws-internet-gateway"
  igw                                   = var.igw
  common_tags                           = var.common_tags
  depends_on                            = [ module.vpc ]
}

module "nat" {
  source                                = "../modules/aws-nat"
  nat                                   = var.nat
  common_tags                           = var.common_tags
  depends_on                            = [ module.subnets ]
}

module "public_root_table" {
  source                                = "../modules/aws-route-table-igw"
  route_table_igw                       = var.route_table_igw
  common_tags                           = var.common_tags
  depends_on                            = [ module.vpc, module.subnets, module.igw ]
}

module "private_root_table" {
  source                                = "../modules/aws-route-table-nat"
  route_table_nat                       = var.route_table_nat
  common_tags                           = var.common_tags
  depends_on                            = [ module.vpc, module.subnets, module.nat ]
}
/*
module "rds" {
  source                                = "../modules/aws-rds"
  rds                                   = var.rds
  common_tags                           = var.common_tags
  depends_on                            = [ module.subnets, module.rds_security_group ]
}
*/
module "ec2_1" {
  source                                = "../modules/aws-ec2-instance"
  ec2                                   = var.ec2
  common_tags                           = var.common_tags  
  public_key_contents                   = var.public_key_contents
  depends_on                            = [ module.ec2_1_security_group, module.subnets, /*module.rds, */module.load_balancer ]
}

module "load_balancer" {
  source                                = "../modules/aws-load-balancer"
  load_balancer                         = var.load_balancer
  common_tags                           = var.common_tags
  depends_on                            = [ module.subnets ]
}

module "tg_80" {
  source                                = "../modules/aws-target-group"
  target_group                          = var.tg_80
  common_tags                           = var.common_tags
  depends_on                            = [ module.vpc, module.ec2_1, module.load_balancer ]
}

module "ec2_1_security_group" {
  source                                = "../modules/aws-security-group"
  security_group                        = var.sec_1
  ingress_from_existent_security_groups = var.ingress_from_existent_security_groups_for_sec_1
  common_tags                           = var.common_tags
  depends_on                            = [ module.vpc ]
}
/*
module "rds_security_group" {
  source                                = "../modules/aws-security-group"
  security_group                        = var.sec_2
  ingress_from_existent_security_groups = var.ingress_from_existent_security_groups_for_sec_2
  common_tags                           = var.common_tags
  depends_on                            = [ module.vpc, module.ec2_1_security_group ]
  
}
*/

