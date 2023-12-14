provider "aws" {
    region = "eu-west-2"
  
}

data "aws_instances" "instance_ids" {
    instance_tags        = {
      Name               = "Instance 1"
    }

    instance_state_names = ["running", "pending"]
}

output "name" {
  value = data.aws_instances.instance_ids
}