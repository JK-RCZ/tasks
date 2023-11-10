#  This module depends on VPC, Instance and Load Balancer.
#  Please set respective dependensies in root module!

data "aws_vpc" "data" {
    tags             = {
      Name           = var.target_group.vpc_name
    }
  
}

data "aws_instance" "data" {
    tags             = {
      Name           = var.target_group.instance_name
    }
  
}

data "aws_lb" "data" {
    tags             = {
      Name           = var.target_group.load_balancer_name
    }
  
}

resource "aws_lb_target_group" "einz" {
  name               = var.target_group.tg_name
  port               = var.target_group.tg_port
  protocol           = var.target_group.tg_protocol
  vpc_id             = data.aws_vpc.data.id
  target_type        = var.target_group.tg_target_type
  tags               = merge(var.common_tags, {Name = "${var.target_group.tg_name}"})
  
}

resource "aws_lb_target_group_attachment" "zwei" {
  target_group_arn   = aws_lb_target_group.einz.arn
  target_id          = data.aws_instance.data.id
  port               = var.target_group.tg_port
}

resource "aws_lb_listener" "drei" {
  load_balancer_arn  = data.aws_lb.data.id
  port               = var.target_group.tg_port
  protocol           = var.target_group.tg_protocol
  tags               = merge(var.common_tags, {Name = "${var.target_group.tg_name} listener"})
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.einz.id
  }
}