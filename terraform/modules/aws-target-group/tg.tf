#  This module depends on VPC, Instance and Load Balancer.
#  Please set respective dependensies in root module!

resource "aws_lb_target_group" "this" {
  name                   = var.target_group.tg_name
  port                   = var.target_group.tg_port
  protocol               = var.target_group.tg_protocol
  vpc_id                 = data.aws_vpc.vpc_id.id
  target_type            = var.target_group.tg_target_type
  tags                   = merge(var.common_tags, {Name = "${var.target_group.tg_name}"})
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn       = aws_lb_target_group.this.arn
  target_id              = data.aws_instances.instance_ids.ids[0]
  port                   = var.target_group.tg_port
}

resource "aws_lb_listener" "this" {
  load_balancer_arn      = data.aws_lb.lb_id.id
  port                   = var.target_group.tg_port
  protocol               = var.target_group.tg_protocol
  tags                   = merge(var.common_tags, {Name = "${var.target_group.listener_name}"})
  
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.this.id
  }
}