# This module depends on Load Balancer Listener and Target Group.

variable "listener_rule" {
    description                         = "Load balancer listener rule parameters"
    type                                = object({
        listener_rule_parameters        = object({
          name                          = string
          action_type                   = string
          priority                      = string
          path_pattern_values           = list(string)
          
        })
        environment_parameters          = object({
          listener_name                 = string
          target_group_name             = string
          load_balancer_name            = string
        })
    })
}

variable "common_tags" {
    description                         = "Tags suitable for all resources"
    type                                = map
}