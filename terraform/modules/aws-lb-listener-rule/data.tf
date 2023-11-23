
data "aws_lb_listener" "data" {
    load_balancer_arn = data.aws_lb.data.arn
    port = data.aws_lb_target_group.data.port
    tags             = {
      Name           = var.listener_rule.environment_parameters.listener_name
    }
  depends_on = [ data.aws_lb.data, data.aws_lb_target_group.data ]
}

data "aws_lb_target_group" "data" {
    tags             = {
      Name           = var.listener_rule.environment_parameters.target_group_name
    }
  
}