output "ENVIRONMENT" {
    value = [ module.vpc, module.subnets, module.igw, module.nat, module.public_root_table, module.private_root_table ]
}
