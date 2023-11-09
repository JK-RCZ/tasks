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
  source                  = "../modules/aws-igw"
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

data "aws_internet_gateway" "out" {
  tags                    = {
    Name                  = var.igw_name
  }
  depends_on              = [ module.igw ]
}

module "public_root_table" {
  source                  = "../modules/aws-route-table-igw"
  igw_route_table_params  = var.igw_route_table_params
  vpc_id                  = data.aws_vpc.vpc.id
  route_table_target_id   = data.aws_internet_gateway.out.id
  common_tags             = var.common_tags
  depends_on              = [ module.subnets ]
}

data "aws_nat_gateway" "out" {
  tags                    = {
    Name                  = var.nat.name
  }
  depends_on              = [ module.nat ]
}

module "private_root_table" {
  source                  = "../modules/aws-route-table-nat"
  nat_route_table_params  = var.nat_route_table_params
  vpc_id                  = data.aws_vpc.vpc.id
  route_table_target_id   = data.aws_nat_gateway.out.id
  common_tags             = var.common_tags
  depends_on              = [ module.subnets ]
}
