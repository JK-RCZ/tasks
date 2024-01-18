
common_tags                                            = {
  Owner                                                = "Jan Karczewski"
  Project                                              = "El Gato"
  Environment                                          = "Dev"
}

vpc                                                    = {
  region                                               = "eu-west-2"
  tenancy                                              = "default"
  cidr_block                                           = "10.0.0.0/16"
  name                                                 = "el-gato-vpc"
  ebs_encryption_params                                = {
    enable_ebs_encryption                              = "true"
    deletion_window_in_days                            = "10"
    customer_master_key_spec                           = "SYMMETRIC_DEFAULT"
  }
}

subnets                                                = {
  subnets_params                                       = [ 
    {
      name                                             = "Private Subnet 1"
      cidr_block                                       = "10.0.0.0/18"
      map_public_ip_on_launch                          = false
      availability_zone                                = "eu-west-2a"
    },
    {
      name                                             = "Private Subnet 2"
      cidr_block                                       = "10.0.64.0/18"
      map_public_ip_on_launch                          = false
      availability_zone                                = "eu-west-2b"
    },
    {
      name                                             = "Public Subnet 1"
      cidr_block                                       = "10.0.128.0/18"
      map_public_ip_on_launch                          = true
      availability_zone                                = "eu-west-2a"
    },
    {
      name                                             = "Public Subnet 2"
      cidr_block                                       = "10.0.192.0/18"
      map_public_ip_on_launch                          = true
      availability_zone                                = "eu-west-2b"
    }
  ]
  vpc_name                                             = "el-gato-vpc"
}

igw                                                    = {
  igw_name                                             = "LGO"
  vpc_name                                             = "el-gato-vpc"
}

nat                                                    = {
  domain                                               = "vpc"
  private_subnet_name                                  = [ "Private Subnet 1", "Private Subnet 2"]
  public_subnet_name                                   = [ "Public Subnet 1",  "Public Subnet 2" ]
  nat_name                                             = [ "NAT 1",            "NAT 2"           ]
}


route_table_igw                                        = {
  name                                                 = "Public"
  destination_cidr_block                               = "0.0.0.0/0"
  igw_name                                             = "LGO"
  subnet_name                                          = [ "Public Subnet 1", "Public Subnet 2" ]
  vpc_name                                             = "el-gato-vpc"
}

route_table_nat                                        = {
  destination_cidr_block                               = "0.0.0.0/0"
  vpc_name                                             = "el-gato-vpc"
  private_subnet_name                                  = [ "Private Subnet 1", "Private Subnet 2" ]
  route_table_name                                     = [ "Private 1",        "Private 2"        ]
  nat_name                                             = [ "NAT 1",            "NAT 2"            ]


}

ec2                                                    = {
  public_key_name                                      = "aws-lamp"
  vpc_name                                             = "el-gato-vpc"
  instance_parameters                                  = {
    instance_name                                      = "Instance 1"
    instance_ami                                       = "ami-0b6384181e01b87fb" # Amazon-Linux
    instance_type                                      = "t2.micro"
    subnet_name                                        = "Private Subnet 1"
    associate_public_ip_address                        = false
    user_data_path                                     = "scripts/install-LAMP.sh"
    security_group_names                               = [ "Sec 1"]
    volume_path                                        = "/dev/sdh"
    volume_size_gb                                     = "10"
  }
  rds_instance_parameters                              = {
    gather_rds_instance_data                           = true
    rds_instance_name                                  = "mariadb"
    ssm_key_name                                       = "mariadb_pass"
    load_balancer_name                                 = "fair"
  }
  instance_profile_parameters                          = {
    create_instance_profile                            = true
    instance_profile_name                              = "ssm-s3-connection"
    attach_role_name                                   = "ec2-connect-to-ssm-s3"
  }
}


load_balancer                                          = {
  load_balancer_name                                   = "fair"
  internal_load_balancer                               = false
  load_balancer_type                                   = "application"
  security_group_names                                 = [ "Sec 1" ]
  subnet_names                                         = [ "Public Subnet 1", "Public Subnet 2" ]
  enable_deletion_protection                           = false
}

tg_80                                                  = {
  tg_name                                              = "Instance-1-Wordpress"
  tg_port                                              = "80"
  tg_protocol                                          = "HTTP"
  tg_target_type                                       = "instance"
  listener_name                                        = "tg-80-listener"
  vpc_name                                             = "el-gato-vpc"
  instance_name                                        = "Instance 1"
  load_balancer_name                                   = "fair"
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
    rds_security_group_names                           = [ "Sec 2" ]
  }
  password_params                                      = {
    name                                               = "mariadb_pass"
    length                                             = "8"
    type                                               = "SecureString"
  }
}

security_1                                             = {
  vpc_name                                             = "el-gato-vpc"
  sg_name                                              = "Sec 1"
  sg_descritption                                      = "Allow 80, 8001 inbound from 0.0.0.0/0, allow all outbound to 0.0.0.0/0"
  ingress                                              = [ 
    {
      ingress_description                              = "allow all port 80"
      ingress_port                                     = "80"
      ingress_protocol                                 = "tcp"
      ingress_cidr_blocks                              = [ "0.0.0.0/0" ]
      ingress_ipv6_cidr_blocks                         = []
      ingress_prefix_list_ids                          = []
      ingress_self                                     = false
    },
    {
      ingress_description                              = "allow all port 8001"
      ingress_port                                     = "8001"
      ingress_protocol                                 = "tcp"
      ingress_cidr_blocks                              = [ "0.0.0.0/0" ]
      ingress_ipv6_cidr_blocks                         = []
      ingress_prefix_list_ids                          = []
      ingress_self                                     = false
    }
  ]
  egress                                               = {
      egress_description                               = "allow all egress to 0.0.0.0/0"
      egress_port                                      = "0"
      egress_protocol                                  = "-1"
      egress_cidr_blocks                               = [ "0.0.0.0/0" ]
  }
}

security_2                                             = {
  vpc_name                                             = "el-gato-vpc"
  sg_name                                              = "Sec 2"
  sg_descritption                                      = "Allow 3306 inbound from security group sec_1, deny all outbound"
  ingress                                              = [ 
    {
      ingress_description                              = "allow port 3306 from sec_1"
      ingress_port                                     = "3306"
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

allow_from_security_groups_1                           = []
allow_from_security_groups_2                           = [ "Sec 1" ]

iam_policy = {
  policy_name = "allow-ec2ssm-s3putobject-kmsgeneratekey"
  policy_path = "/"
  policy_json_file_path = "./policies/ssm-s3-kms-policy.json"
}

ec2_role                                               = {
  iam_role_name                                        = "ec2-connect-to-ssm-s3"
  trusted_entities_policy_file_path                    = "./policies/trusted-entity-ec2-policy.json"
  policy_name                                          = "allow-ec2ssm-s3putobject-kmsgeneratekey"
}

s3_bucket                                              = {
  bucket_name                                          = "lil-pretty-bucket"
  bucket_versioning                                    = "Enabled" 
  s3_encryption_params                                 = {
    enble_encryption                                   = true
    customer_master_key_spec                           = "SYMMETRIC_DEFAULT"
    deletion_window_in_days                            = "10"
    
  }
  s3_intelligent_tiering_params                        = {
    enable_intelligent_tiering                         = true
    intelligent_tiering_config_name                    = "lil-pretty-bucket-intelligent-tiering"  
    days_after_deep_archive_access_allowed             = "180"
    days_after_archive_access_allowed                  = "125"
  }
}

