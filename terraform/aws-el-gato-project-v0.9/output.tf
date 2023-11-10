output "ENVIRONMENT" {
    value = [ module.vpc, module.subnets, module.igw, module.nat, module.public_root_table, module.private_root_table, module.ec2_1, module.load_balancer, module.target_group ]
}

#output "test" {
#    value = data.aws_nat_gateway.test
  
#}