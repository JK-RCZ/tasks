vpc_region                                             = "eu-north-1"

common_tags                                            = {
  Owner                                                = "Jan Karczewski"
  Project                                              = "lamp-k8s"
  Environment                                          = "Dev"
}

rds                                                    = {
  rds_params                                           = {
    subnet_names                                       = [ "Private Subnet 1", "Private Subnet 2" ]
    rds_instance_name                                  = "mariadb"
    rds_family                                         = "mariadb10.6"
    rds_allocated_storage                              = "20"
    rds_storage_type                                   = "gp2"
    rds_db_name                                        = "wordpress"
    rds_engine                                         = "mariadb"
    rds_engine_version                                 = "10.6.14"
    rds_instance_class                                 = "db.t3.micro"
    rds_username                                       = "henry"
    rds_skip_final_snapshot                            = true
    rds_publicly_accessible                            = false
    rds_security_group_names                           = [ "mariadb-security" ]
  }
  password_params                                      = {
    name                                               = "mariadb_pass"
    length                                             = "8"
    type                                               = "SecureString"
  }
}

rds_security_group                                     = {
  vpc_name                                             = "k8s-vpc"
  sg_name                                              = "mariadb-security"
  sg_descritption                                      = "Allow 3306 inbound from security group mariadb-security, deny all outbound"
  traffic_from_security_groups_only                    = {
      allow_traffic                                    = true
      security_groups_names                            = ["mariadb-security"]
  }
  ingress                                              = [ 
    {
      ingress_description                              = "allow port TCP 3306 from mariadb-security"
      ingress_from_port                                = "3306"
      ingress_to_port                                  = "3306"
      ingress_protocol                                 = "tcp"
      ingress_cidr_blocks                              = []
      ingress_ipv6_cidr_blocks                         = []
      ingress_prefix_list_ids                          = []
      ingress_self                                     = false
    }
  ]
  egress                                               = {
      egress_description                               = "deny all egress"
      egress_port                                      = "0"
      egress_protocol                                  = "0"
      egress_cidr_blocks                               = []
  }
}

other_parameters = {
  ssm_key_name = "mariadb_pass"
}


