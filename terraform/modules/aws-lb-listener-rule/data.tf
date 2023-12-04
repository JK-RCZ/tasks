
data "aws_lb_listener" "listener_arn" {
    load_balancer_arn = data.aws_lb.load_balancer_arn.arn
    port = data.aws_lb_target_group.target_group_arn.port
    tags             = {
      Name           = var.listener_rule.environment_parameters.listener_name
    }
  depends_on = [ data.aws_lb.load_balancer_arn, data.aws_lb_target_group.target_group_arn ]
}

data "aws_lb" "load_balancer_arn" {
  name = var.listener_rule.environment_parameters.load_balancer_name  
}

data "aws_lb_target_group" "target_group_arn" {
    tags             = {
      Name           = var.listener_rule.environment_parameters.target_group_name
    }
  
}