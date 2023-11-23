#This module depends on Security Group and Subnets. 
# Please set respective dependensies in root module!

resource "aws_lb" "this" {
  name                        = var.load_balancer.load_balancer_name
  internal                    = var.load_balancer.internal_load_balancer
  load_balancer_type          = var.load_balancer.load_balancer_type
  security_groups             = local.security_group_ids
  subnets                     = local.subnet_ids
  enable_deletion_protection  = var.load_balancer.enable_deletion_protection

  tags                        = merge(var.common_tags, {Name = "${var.load_balancer.load_balancer_name}"})
}
