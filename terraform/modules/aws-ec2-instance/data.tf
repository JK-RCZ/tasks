
data "aws_subnet" "data" {
    tags                      = {
      Name                    = var.ec2.instance_parameters.subnet_name
    }
}

data "aws_security_group" "data" {
  for_each                    = toset(var.ec2.instance_parameters.security_group_names)
  tags                        = {
    Name                      = each.key
  }
}

data "aws_db_instance" "data" {
  count                       = var.ec2.rds_instance_parameters.gather_rds_instance_data ? 1 : 0
  tags                        = {
    Name                      = var.ec2.rds_instance_parameters.rds_instance_name
  }
}

data "aws_ssm_parameter" "data" {
  count                       = var.ec2.rds_instance_parameters.gather_rds_instance_data ? 1 : 0
  name = var. ec2.rds_instance_parameters.ssm_name
}

data "aws_lb" "data" {
  count                       = var.ec2.rds_instance_parameters.gather_rds_instance_data ? 1 : 0
  name = var.ec2.rds_instance_parameters.load_balancer_name
}
