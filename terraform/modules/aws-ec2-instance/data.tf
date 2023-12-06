
data "aws_subnet" "subnet_id" {
    tags                      = {
      Name                    = var.ec2.instance_parameters.subnet_name
    }
}

data "aws_security_group" "security_group_id" {
  for_each                    = toset(var.ec2.instance_parameters.security_group_names)
  tags                        = {
    Name                      = each.key
  }
}

data "aws_db_instance" "db_credentials" {
  count                       = var.ec2.rds_instance_parameters.gather_rds_instance_data ? 1 : 0
  tags                        = {
    Name                      = var.ec2.rds_instance_parameters.rds_instance_name
  }
}

data "aws_ssm_parameter" "db_password" {
  count                       = var.ec2.rds_instance_parameters.gather_rds_instance_data ? 1 : 0
  name                        = var. ec2.rds_instance_parameters.ssm_name
}

data "aws_lb" "lb_dns_name" {
  count                       = var.ec2.rds_instance_parameters.gather_rds_instance_data ? 1 : 0
  name                        = var.ec2.rds_instance_parameters.load_balancer_name
}
