#  This module depends on Subnets and Security Groups.
#  Please set respective dependensies in root module!

resource "aws_db_subnet_group" "this" {
  name                     = "${var.rds.rds_params.rds_instance_name}_subnet_group"
  subnet_ids               = local.subnet_ids

  tags                     = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}_subnet_group"})
}

resource "aws_db_parameter_group" "this" {
  family                   = var.rds.rds_params.rds_family
  tags                     = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}_parameter_group"})
}

resource "random_string" "this" {
  length                   = var.rds.password_params.length
  special                  = false
}

resource "aws_ssm_parameter" "this" {
  name                     = "${var.rds.password_params.name}" 
  type                     = var.rds.password_params.type
  value                    = random_string.this.result
  tags                     = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}"})
}

resource "aws_db_instance" "this" {
  identifier               = var.rds.rds_params.rds_instance_name
  allocated_storage        = var.rds.rds_params.rds_allocated_storage
  storage_type             = var.rds.rds_params.rds_storage_type
  db_name                  = var.rds.rds_params.rds_db_name
  engine                   = var.rds.rds_params.rds_engine
  engine_version           = var.rds.rds_params.rds_engine_version
  instance_class           = var.rds.rds_params.rds_instance_class
  username                 = var.rds.rds_params.rds_username
  password                 = aws_ssm_parameter.this.value
  parameter_group_name     = aws_db_parameter_group.this.name
  skip_final_snapshot      = var.rds.rds_params.rds_skip_final_snapshot
  db_subnet_group_name     = aws_db_subnet_group.this.name
  vpc_security_group_ids   = local.sg_ids
  publicly_accessible      = var.rds.rds_params.rds_publicly_accessible
  depends_on               = [ aws_ssm_parameter.this, aws_db_subnet_group.this, aws_db_parameter_group.this ]

  tags                     = merge(var.common_tags, {Name = "${var.rds.rds_params.rds_instance_name}"})
}
