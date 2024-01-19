module "rds_mariadb" {
  source = "../modules/aws-rds"
  rds = var.rds
  common_tags = var.common_tags
}

module "rds_security_group" {
  source = "../modules/aws-security-group"
  security_group = var.rds_security_group
  common_tags = var.common_tags
}