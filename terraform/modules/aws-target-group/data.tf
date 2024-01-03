
data "aws_vpc" "vpc_id" {
    tags                 = {
      Name               = var.target_group.vpc_name
    }
}

data "aws_instances" "instance_ids" {
    instance_tags        = {
      Name               = var.target_group.instance_name
    }

    instance_state_names = ["running", "pending"]
}

data "aws_lb" "lb_id" {
    tags                 = {
      Name               = var.target_group.load_balancer_name
    }
}