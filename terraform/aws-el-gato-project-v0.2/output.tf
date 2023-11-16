
output "ENVIRONMENT" {
    value = [ 
        module.vpc, 
        module.subnets, 
        module.igw, 
        module.nat, 
        module.public_root_table, 
        module.private_root_table, 
        module.ec2_1, 
        module.load_balancer, 
        module.tg_80,
        module.tg_8001,
        module.ec2_1_security_group,
        /*module.rds_security_group,
        module.rds*/ 
    ]
}
