data "aws_instances" "data" {
    instance_tags        = {
      Name               = "Instance 1"
    }

    instance_state_names = ["running", "pending"]
}
output "name" {
    value = data.aws_instances.data
  
}