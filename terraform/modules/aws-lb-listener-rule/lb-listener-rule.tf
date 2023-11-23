# This module depends on Load Balancer Listener and Target Group.
# Please set respective dependensies in root module!

resource "aws_lb_listener_rule" "this" {
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
  tags               = merge(var.common_tags, {Name = "${var.listener_rule.listener_rule_parameters.name}"})
}
