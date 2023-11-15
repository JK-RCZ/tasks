module "vpc" {
  source                   = "../modules/aws-vpc"
  vpc                      = {
    region                 = var.vpc.region
    tenancy                = var.vpc.tenancy
    cidr_block             = var.vpc.cidr_block
    name                   = var.vpc.name
    }
  common_tags              = var.common_tags
}

data "aws_vpc" "vpc" {
  
  tags                     = {
    Name                   = var.vpc.name
  }
  depends_on               = [ module.vpc ]
 
}

module "subnets" {
  source                   = "../modules/aws-subnet"
  subnets                  = var.subnets
  vpc_id                   = data.aws_vpc.vpc.id
  common_tags              = var.common_tags
  
}

module "igw" {
  source                   = "../modules/aws-internet-gateway"
  vpc_id                   = data.aws_vpc.vpc.id
  igw_name                 = var.igw_name
  common_tags              = var.common_tags
}

module "nat" {
  source                   = "../modules/aws-nat"
  nat                      = var.nat
  common_tags              = var.common_tags
  depends_on               = [ module.subnets ]
}

module "public_root_table" {
  source                   = "../modules/aws-route-table-igw"
  igw_route_table_params   = var.igw_route_table_params
  vpc_id                   = data.aws_vpc.vpc.id
  common_tags              = var.common_tags
  depends_on               = [ module.subnets, module.igw ]
}

module "private_root_table" {
  source                   = "../modules/aws-route-table-nat"
  nat_route_table_params   = var.nat_route_table_params
  vpc_id                   = data.aws_vpc.vpc.id
  common_tags              = var.common_tags
  depends_on               = [ module.subnets, module.nat ]
}
/*
module "rds" {
  source                   = "../modules/aws-rds"
  rds                      = var.rds
  common_tags              = var.common_tags
  depends_on               = [ module.subnets, module.rds_security_group ]
}

data "aws_db_instance" "data" {
  tags                     = {
    Name                   = var.rds.rds_params.rds_instance_name
  }
  depends_on               = [ module.rds ]
}

resource "terraform_data" "export_rds_endpoint" {
  provisioner "local-exec" {
    command                = "export db_endpoint=${data.aws_db_instance.data.address}"
  }
  depends_on               = [ data.aws_db_instance.data ]
}

resource "terraform_data" "launch_inject_script" {
  triggers_replace         = [timestamp()]
  provisioner "local-exec" {
    command                = "script/inject-parameters-in-containers.sh"
  }
  depends_on               = [ resource.terraform_data.export_rds_endpoint ]
}
*/
module "ec2_1" {
  source                   = "../modules/aws-ec2-instance"
  ec2                      = var.ec2
  common_tags              = var.common_tags  
  public_key_contents      = var.public_key_contents
  depends_on               = [ module.ec2_1_security_group, module.subnets, /*module.rds,*/ module.load_balancer ]
}

module "load_balancer" {
  source                   = "../modules/aws-load-balancer"
  load_balancer            = var.load_balancer
  common_tags              = var.common_tags
  depends_on               = [ module.subnets ]
}

module "tg_80" {
  source                   = "../modules/aws-target-group"
  target_group             = var.tg_80
  common_tags              = var.common_tags
  depends_on               = [ module.vpc, module.ec2_1, module.load_balancer ]
}

module "tg_8001" {
  source                   = "../modules/aws-target-group"
  target_group             = var.tg_8001
  common_tags              = var.common_tags
  depends_on               = [ module.vpc, module.ec2_1, module.load_balancer ]
  
}

module "ec2_1_security_group" {
  source = "../modules/aws-security-group"
  security_group = var.sec_1
  ingress_from_existent_security_groups = var.ingress_from_existent_security_groups_for_sec_1
  common_tags = var.common_tags
  depends_on = [ module.vpc ]
}
/*
module "rds_security_group" {
  source = "../modules/aws-security-group"
  security_group = var.sec_2
  ingress_from_existent_security_groups = var.ingress_from_existent_security_groups_for_sec_2
  common_tags = var.common_tags
  depends_on = [ module.vpc, module.ec2_1_security_group ]
  
}
*/