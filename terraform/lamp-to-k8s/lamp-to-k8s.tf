/*module "rds_mariadb" {
  source = "../modules/aws-rds"
  rds = var.rds
  common_tags = var.common_tags
}

module "rds_security_group" {
  source = "../modules/aws-security-group"
  security_group = var.rds_security_group
  common_tags = var.common_tags
}

#data "aws_ssm_parameter" "db_password" {
#  name                        = var.other_parameters.ssm_key_name
#}
*/
resource "terraform_data" "launch_lamp" {
  provisioner "local-exec" {
    command = "/home/ykarchevsky/tasks/terraform/lamp-to-k8s/scripts/launch-remote-script.sh"
    interpreter = ["bash"]
  }
}
