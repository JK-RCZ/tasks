#  This module depends on VPC, Instance and Load Balancer.
#  Please set respective dependensies in root module!

data "aws_vpc" "data" {
    tags                 = {
      Name               = var.target_group.vpc_name
    }
  
}

data "aws_instances" "data" {
    instance_tags        = {
      Name               = var.target_group.instance_name
    }

    instance_state_names = ["running", "pending"]
}

data "aws_lb" "data" {
    tags                 = {
      Name               = var.target_group.load_balancer_name
    }
  
}

resource "aws_lb_target_group" "einz" {
  name                   = var.target_group.tg_name
  port                   = var.target_group.tg_port
  protocol               = var.target_group.tg_protocol
  vpc_id                 = data.aws_vpc.data.id
  target_type            = var.target_group.tg_target_type
  tags                   = merge(var.common_tags, {Name = "${var.target_group.tg_name}"})
  
}

resource "aws_lb_target_group_attachment" "zwei" {
  target_group_arn       = aws_lb_target_group.einz.arn
  target_id              = data.aws_instances.data.ids[0]
  port                   = var.target_group.tg_port
}

resource "aws_lb_listener" "drei" {
  load_balancer_arn      = data.aws_lb.data.id
  port                   = var.target_group.tg_port
  protocol               = var.target_group.tg_protocol
  tags                   = merge(var.common_tags, {Name = "${var.target_group.listener_name}"})
  
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.einz.id
  }
}