output "Environment-parameters" {
    description = "Environment data"
    value = [module.dev-environment-net, module.dev-environment-instance]
}

#output "RDS" {
#  value = data.aws_rds_orderable_db_instance.rds-list
#}

#output "secur-groups" {
#    value = data.aws_security_groups.secur
#  
#}

