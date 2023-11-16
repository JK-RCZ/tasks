# This module depends on Load balancer, Load Balancer Listener, Target Group.
# Please set respective dependensies in root module!

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

data "aws_lb" "data" {
    tags             = {
      Name           = var.listener_rule.environment_parameters.lb_name
    }
  
}

resource "aws_lb_listener_rule" "thing" {
  listener_arn       = data.aws_lb_listener.data.arn
  priority           = var.listener_rule.listener_rule_parameters.priority

  action {
    type             = var.listener_rule.listener_rule_parameters.action_type
    target_group_arn = data.aws_lb_target_group.data.arn
  }

  condition {
    path_pattern {
      values         = var.listener_rule.listener_rule_parameters.path_pattern_values
    }
  }

  condition {
    host_header {
      values         = [ data.aws_lb.data.dns_name ]
    }
  }
  tags               = merge(var.common_tags, {Name = "${var.listener_rule.listener_rule_parameters.name}"})
}
