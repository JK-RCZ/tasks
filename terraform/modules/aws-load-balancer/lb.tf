#This module depends on security group and subnets please set respective dependensies in root module

data "aws_security_group" "data" {
    for_each                  = toset(var.load_balancer.security_group_names)
    tags                      = {
      Name                    = each.key
    }
}

data "aws_subnet" "data" {
    for_each                  = toset(var.load_balancer.subnet_names)
    tags                      = {
      Name                    = each.key
    }
}

resource "aws_lb" "thing" {
  name                        = var.load_balancer.load_balancer_name
  internal                    = var.load_balancer.internal_load_balancer
  load_balancer_type          = var.load_balancer.load_balancer_type
  security_groups             = local.security_group_ids
  subnets                     = local.subnet_ids
  enable_deletion_protection  = var.load_balancer.enable_deletion_protection

  tags                        = merge(var.common_tags, {Name = "${var.load_balancer.load_balancer_name}"})
}
