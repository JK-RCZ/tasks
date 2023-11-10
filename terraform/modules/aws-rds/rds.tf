#  This module depends on Subnets, VPC, Security Groups, 
#  Please set respective dependensies in root module!

data "aws_subnet" "data" {
    for_each = toset(var.rds.rds_params.subnet_names)
    tags = {
      Name = each.key
    }
}

data "aws_vpc" "data" {
    tags = {
      Name = var.rds.security_group_params.vpc_name
    }
  
}

data "aws_security_group" "data" {
    for_each = toset(var.rds.security_group_params.security_group_names)
    tags = {
      Name = each.key
    }
}


resource "aws_db_subnet_group" "einz" {
  name = var.rds_instance.rds_instance_name
  subnet_ids = local.subnet_ids

  tags = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name} subnet group"})
}

resource "aws_db_parameter_group" "zwei" {
  family = var.rds.rds_params.rds_family
  tags = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name} parameter group"})
}

resource "random_string" "drei" {
  length = var.rds.password_params.length
  special = false
}

resource "aws_ssm_parameter" "vier" {
  name = "${var.rds.rds_params.rds_instance_name}-password" 
  type = var.rds.password_params.type
  value = random_string.drei.result
  tags = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}-password"})
}

resource "aws_security_group" "fünf" {
  description = "Allow inbound traffic from ec2"
  vpc_id      = data.aws_vpc.data.id
  ingress     = [{
    description            = "mariaDB"
    from_port              = 3306
    to_port                = 3306
    protocol               = "tcp"
    cidr_blocks            = var.rds.security_group_params.cidr_block
    ipv6_cidr_blocks       = var.rds.security_group_params.ipv6_cidr_blocks
    prefix_list_ids        = var.rds.security_group_params.prefix_list_ids
    self                   = var.rds.security_group_params.self
    security_groups        = local.sg_ids
  }]
  egress                   = []
  tags                     = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}"-sg})
}

resource "aws_db_instance" "sechs" {
  identifier             = var.rds.rds_params.rds_instance_name
  allocated_storage      = 
  storage_type           = 
  db_name                = 
  engine                 = 
  engine_version         = 
  instance_class         = 
  username               = 
  password               = aws_ssm_parameter.vier.value
  parameter_group_name   = aws_db_parameter_group.zwei.name
  skip_final_snapshot    = 
  db_subnet_group_name   = aws_db_subnet_group.einz.name
  vpc_security_group_ids = [aws_security_group.fünf.id] 
  publicly_accessible    = 
  depends_on             = [ aws_ssm_parameter.ssm-rds-vier ]

  tags = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}"})
}
