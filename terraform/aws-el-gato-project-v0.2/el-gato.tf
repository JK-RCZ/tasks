
module "vpc" {
  source                                = "../modules/aws-vpc"
  vpc                                   = {
    region                              = var.vpc.region
    tenancy                             = var.vpc.tenancy
    cidr_block                          = var.vpc.cidr_block
    name                                = var.vpc.name
    ebs_encryption_params               = var.vpc.ebs_encryption_params
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
  depends_on                            = [ module.ec2_1_security_group, module.subnets, /*module.rds, */module.load_balancer, module.ec2_role ]
}

module "load_balancer" {
  source                                = "../modules/aws-load-balancer"
  load_balancer                         = var.load_balancer
  common_tags                           = var.common_tags
  depends_on                            = [ module.subnets ]
}

module "target_group_port_80" {
  source                                = "../modules/aws-target-group"
  target_group                          = var.tg_80
  common_tags                           = var.common_tags
  depends_on                            = [ module.vpc, module.ec2_1, module.load_balancer ]
}

module "ec2_1_security_group" {
  source                                = "../modules/aws-security-group"
  security_group                        = var.security_1
  allow_from_security_groups            = var.allow_from_security_groups_1
  common_tags                           = var.common_tags
  depends_on                            = [ module.vpc ]
}

/*
module "rds_security_group" {
  source                                = "../modules/aws-security-group"
  security_group                        = var.security_2
  allow_from_security_groups            = var.allow_from_security_groups_2
  common_tags                           = var.common_tags
  depends_on                            = [ module.vpc, module.ec2_1_security_group ]
}
*/
module "ec2_role" {
  source                                = "../modules/aws-iam-role"
  iam_role                              = var.ec2_role
  common_tags                           = var.common_tags 
  depends_on = [ module.ssm_s3_kms_policy ] 
}

module "s3_backup" {
  source = "../modules/aws-s3-bucket"
  s3_bucket = var.s3_bucket
  common_tags = var.common_tags
}

module "ssm_s3_kms_policy" {
  source = "../modules/aws-policy"
  iam_policy = var.iam_policy
  common_tags = var.common_tags
}
