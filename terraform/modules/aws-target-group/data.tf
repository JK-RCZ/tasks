
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