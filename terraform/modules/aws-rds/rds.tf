#  This module depends on Subnets, VPC, Security Groups.
#  Please set respective dependensies in root module!

data "aws_subnet" "data" {
    for_each               = toset(var.rds.rds_params.subnet_names)
    tags                   = {
      Name                 = each.key
    }
}

data "aws_vpc" "data" {
    tags                   = {
      Name                 = var.rds.security_group_params.vpc_name
    }
  
}

data "aws_security_group" "data" {
    for_each               = toset(var.rds.security_group_params.ingress_security_group_names)
    tags                   = {
      Name                 = each.key
    }
}


resource "aws_db_subnet_group" "einz" {
  name                     = "${var.rds.rds_params.rds_instance_name}_subnet_group"
  subnet_ids               = local.subnet_ids

  tags                     = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}_subnet_group"})
}

resource "aws_db_parameter_group" "zwei" {
  family                   = var.rds.rds_params.rds_family
  tags                     = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}_parameter_group"})
}

resource "random_string" "drei" {
  length                   = var.rds.password_params.length
  special                  = false
}

resource "aws_ssm_parameter" "vier" {
  name                     = "${var.rds.rds_params.rds_instance_name}-password" 
  type                     = var.rds.password_params.type
  value                    = random_string.drei.result
  tags                     = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}-password"})
}

resource "aws_security_group" "fünf" {
  description              = "Allow inbound traffic from ec2"
  vpc_id                   = data.aws_vpc.data.id
  ingress                  = [{
    description            = var.rds.security_group_params.ingress_description
    from_port              = var.rds.security_group_params.ingress_port
    to_port                = var.rds.security_group_params.ingress_port
    protocol               = var.rds.security_group_params.ingress_protocol
    cidr_blocks            = var.rds.security_group_params.ingress_cidr_blocks
    ipv6_cidr_blocks       = var.rds.security_group_params.ingress_ipv6_cidr_blocks
    prefix_list_ids        = var.rds.security_group_params.ingress_prefix_list_ids
    self                   = var.rds.security_group_params.ingress_self
    security_groups        = local.sg_ids
  }]
  egress                   = []
  tags                     = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}-sg"})
}

resource "aws_db_instance" "sechs" {
  identifier               = var.rds.rds_params.rds_instance_name
  allocated_storage        = var.rds.rds_params.rds_allocated_storage
  storage_type             = var.rds.rds_params.rds_storage_type
  db_name                  = var.rds.rds_params.rds_db_name
  engine                   = var.rds.rds_params.rds_engine
  engine_version           = var.rds.rds_params.rds_engine_version
  instance_class           = var.rds.rds_params.rds_instance_class
  username                 = var.rds.rds_params.rds_username
  password                 = aws_ssm_parameter.vier.value
  parameter_group_name     = aws_db_parameter_group.zwei.name
  skip_final_snapshot      = var.rds.rds_params.rds_skip_final_snapshot
  db_subnet_group_name     = aws_db_subnet_group.einz.name
  vpc_security_group_ids   = [aws_security_group.fünf.id] 
  publicly_accessible      = var.rds.rds_params.rds_publicly_accessible
  depends_on               = [ aws_ssm_parameter.vier ]

  tags                     = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}"})
}
