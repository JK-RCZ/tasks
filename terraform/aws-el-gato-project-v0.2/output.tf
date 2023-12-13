
output "environment" {
    value = [ 
        module.vpc, 
        module.subnets, 
        module.igw, 
        module.nat, 
        module.public_root_table, 
        module.private_root_table, 
        module.ec2_1, 
        module.load_balancer, 
        module.target_group_port_80,
        module.ec2_1_security_group,
        /*module.rds_security_group,
        module.rds,*/
        module.ssm_s3_kms_policy,
        module.ec2_role,
        module.s3_backup
    ]
}

