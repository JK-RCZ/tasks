
output "environment" {
    value = [ 
        module.vpc, 
        module.subnets, 
        module.igw, 
        module.nat, 
        module.public_root_table, 
        module.private_root_table, 
        module.ec2_master,
        module.ec2_worker,
        module.load_balancer, 
        module.worker_node_target_group_port_80,
        module.k8s_master_node_security_group,
        module.k8s_worker_node_security_group,
        module.ssm_policy,
        module.ec2_role,
        module.s3_buffer
    ]
}

