
common_tags                                              = {
  Owner                                                  = "Jan Karczewski"
  Project                                                = "Kubernetes"
  Environment                                            = "Dev"
}

vpc                                                      = {
  region                                                 = "eu-north-1"
  tenancy                                                = "default"
  cidr_block                                             = "10.0.0.0/18"
  name                                                   = "k8s-vpc"
  ebs_encryption_params                                  = {
    enable_ebs_encryption                                = "true"
    deletion_window_in_days                              = "10"
    customer_master_key_spec                             = "SYMMETRIC_DEFAULT"
  }
}

subnets                                                  = {
  subnets_params                                         = [ 
    {
      name                                               = "Private Subnet 1"
      cidr_block                                         = "10.0.0.0/20"
      map_public_ip_on_launch                            = false
      availability_zone                                  = "eu-north-1a"
    },
    {
      name                                               = "Private Subnet 2"
      cidr_block                                         = "10.0.16.0/20"
      map_public_ip_on_launch                            = false
      availability_zone                                  = "eu-north-1b"
    },
    {
      name                                               = "Public Subnet 1"
      cidr_block                                         = "10.0.32.0/20"
      map_public_ip_on_launch                            = true
      availability_zone                                  = "eu-north-1a"
    },
    {
      name                                               = "Public Subnet 2"
      cidr_block                                         = "10.0.48.0/20"
      map_public_ip_on_launch                            = true
      availability_zone                                  = "eu-north-1b"
    }
  ]
  vpc_name                                               = "k8s-vpc"
}

igw                                                      = {
  igw_name                                               = "k8s-igw"
  vpc_name                                               = "k8s-vpc"
}

nat                                                      = {
  domain                                                 = "vpc"
  private_subnet_name                                    = [ "Private Subnet 1", "Private Subnet 2"]
  public_subnet_name                                     = [ "Public Subnet 1",  "Public Subnet 2" ]
  nat_name                                               = [ "NAT 1",            "NAT 2"           ]
}


route_table_igw                                          = {
  name                                                   = "Public"
  destination_cidr_block                                 = "0.0.0.0/0"
  igw_name                                               = "k8s-igw"
  subnet_name                                            = [ "Public Subnet 1", "Public Subnet 2" ]
  vpc_name                                               = "k8s-vpc"
}

route_table_nat                                          = {
  destination_cidr_block                                 = "0.0.0.0/0"
  vpc_name                                               = "k8s-vpc"
  private_subnet_name                                    = [ "Private Subnet 1", "Private Subnet 2" ]
  route_table_name                                       = [ "Private 1",        "Private 2"        ]
  nat_name                                               = [ "NAT 1",            "NAT 2"            ]


}

s3_bucket                                                = {
  bucket_name                                            = "k8s-buffer-19556"
  bucket_versioning                                      = "Enabled" 
  s3_encryption_params                                   = {
    enble_encryption                                     = true
    customer_master_key_spec                             = "SYMMETRIC_DEFAULT"
    deletion_window_in_days                              = "10"
    
  }
  s3_intelligent_tiering_params                          = {
    enable_intelligent_tiering                           = true
    intelligent_tiering_config_name                      = "lil-pretty-bucket-intelligent-tiering"  
    days_after_deep_archive_access_allowed               = "180"
    days_after_archive_access_allowed                    = "125"
  }
}

ec2_master                                               = {
  public_key_name                                        = "pubkey"
  instance_parameters                                    = {
    instance_name                                        = "k8s-master-node"
    instance_ami                                         = "ami-0014ce3e52359afbd" # Ubuntu "ami-06478978e5e72679a" # Amazon-Linux 
    instance_type                                        = "t3.small"
    subnet_name                                          = "Private Subnet 1"
    associate_public_ip_address                          = false
    user_data_path                                       = "scripts/install-k8s-master-ubuntu.sh"
    security_group_names                                 = [ "k8s-master-node-sg" ]
    volume_path                                          = "/dev/sdh"
    volume_size_gb                                       = "20"
  }
  rds_instance_parameters                                = {
    gather_rds_instance_data                             = false
    rds_instance_name                                    = ""
    ssm_key_name                                         = ""
    load_balancer_name                                   = ""
  }
  instance_profile_parameters                            = {
    create_instance_profile                              = true
    instance_profile_name                                = "ssm-connection1"
    attach_role_name                                     = "ec2-connect-to-ssm1"
  }
}

ec2_worker                                               = {
  public_key_name                                        = "pubkey"
  instance_parameters                                    = {
    instance_name                                        = "k8s-worker-node"
    instance_ami                                         = "ami-0014ce3e52359afbd" # Ubuntu "ami-06478978e5e72679a" # Amazon-Linux
    instance_type                                        = "t3.small"
    subnet_name                                          = "Private Subnet 2"
    associate_public_ip_address                          = false
    user_data_path                                       = "scripts/install-k8s-worker-ubuntu.sh"
    security_group_names                                 = [ "k8s-worker-node-sg" ]
    volume_path                                          = "/dev/sdh"
    volume_size_gb                                       = "20"
  }
  rds_instance_parameters                                = {
    gather_rds_instance_data                             = false
    rds_instance_name                                    = ""
    ssm_key_name                                         = ""
    load_balancer_name                                   = ""
  }
  instance_profile_parameters                            = {
    create_instance_profile                              = true
    instance_profile_name                                = "ssm-connection2"
    attach_role_name                                     = "ec2-connect-to-ssm1"
  }
}

iam_policy                                               = {
  policy_name                                            = "allow-ec2ssm"
  policy_path                                            = "/"
  policy_json_file_path                                  = "./policies/ssm-s3-kms-policy.json"
}

ec2_role_1                                               = {
  iam_role_name                                          = "ec2-connect-to-ssm1"
  trusted_entities_policy_file_path                      = "./policies/trusted-entity-ec2-policy.json"
  policy_name                                            = "allow-ec2ssm"
}

load_balancer                                            = {
  load_balancer_name                                     = "k8s-load-balancer"
  internal_load_balancer                                 = false
  load_balancer_type                                     = "application"
  security_group_names                                   = [ "k8s-worker-node-sg" ]
  subnet_names                                           = [ "Public Subnet 1", "Public Subnet 2"]
  enable_deletion_protection                             = false
}

tg_80                                                    = {
  tg_name                                                = "K8s-worker-node"
  tg_port                                                = "80"
  tg_protocol                                            = "HTTP"
  tg_target_type                                         = "instance"
  listener_name                                          = "tg-80-listener"
  vpc_name                                               = "k8s-vpc"
  instance_name                                          = "k8s-worker-node"
  load_balancer_name                                     = "k8s-load-balancer"
}

security_k8s_master_node                                 = {
  vpc_name                                               = "k8s-vpc"
  sg_name                                                = "k8s-master-node-sg"
  sg_descritption                                        = "Allow TCP 179, UDP 4789, TCP 5473, UDP 51820-51821, UDP 4789, TCP 443, TCP 6443, TCP 2379-2380, TCP 10250, TCP 10259, TCP 10257 inbound from security_k8s_worker_node, allow all outbound to 0.0.0.0/0"
  traffic_from_security_groups_only                      = {
      allow_traffic                                      = false
      security_groups_names                              = []
  }
  ingress                                                = [ 
    {
      ingress_description                                = "allow port TCP 179"
      ingress_from_port                                  = "179"
      ingress_to_port                                    = "179"
      ingress_protocol                                   = "tcp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow port UDP 4789"
      ingress_from_port                                  = "4789"
      ingress_to_port                                    = "4789"
      ingress_protocol                                   = "udp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow port TCP 5473"
      ingress_from_port                                  = "5473"
      ingress_to_port                                    = "5473"
      ingress_protocol                                   = "tcp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow ports UDP 51820-51821"
      ingress_from_port                                  = "51820"
      ingress_to_port                                    = "51821"
      ingress_protocol                                   = "udp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow port UDP 4789"
      ingress_from_port                                  = "4789"
      ingress_to_port                                    = "4789"
      ingress_protocol                                   = "udp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow port TCP 443"
      ingress_from_port                                  = "443"
      ingress_to_port                                    = "443"
      ingress_protocol                                   = "tcp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow port TCP 6443"
      ingress_from_port                                  = "6443"
      ingress_to_port                                    = "6443"
      ingress_protocol                                   = "tcp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow ports TCP 2379-2380"
      ingress_from_port                                  = "2379"
      ingress_to_port                                    = "2380"
      ingress_protocol                                   = "tcp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow port TCP 10250"
      ingress_from_port                                  = "10250"
      ingress_to_port                                    = "10250"
      ingress_protocol                                   = "tcp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow port TCP 10259"
      ingress_from_port                                  = "10259"
      ingress_to_port                                    = "10259"
      ingress_protocol                                   = "tcp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow port TCP 10257"
      ingress_from_port                                  = "10257"
      ingress_to_port                                    = "10257"
      ingress_protocol                                   = "tcp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    }
  ]
  egress                                               = {
      egress_description                               = "allow all outbound to 0.0.0.0/0"
      egress_port                                      = "0"
      egress_protocol                                  = "-1"
      egress_cidr_blocks                               = [ "0.0.0.0/0" ]
  }
}

security_k8s_worker_node                                 = {
  vpc_name                                               = "k8s-vpc"
  sg_name                                                = "k8s-worker-node-sg"
  sg_descritption                                        = "Allow port TCP 80, TCP 10250, TCP 30000-32767 inbound from security_k8s_master_node, allow all outbound to 0.0.0.0/0"
  traffic_from_security_groups_only                      = {
      allow_traffic                                      = false
      security_groups_names                              = [] 
  }
  ingress                                                = [ 
    {
      ingress_description                                = "allow port TCP 80"
      ingress_from_port                                  = "80"
      ingress_to_port                                    = "80"
      ingress_protocol                                   = "tcp"
      ingress_cidr_blocks                                = ["0.0.0.0/0"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow port TCP 10250"
      ingress_from_port                                  = "10250"
      ingress_to_port                                    = "10250"
      ingress_protocol                                   = "tcp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    },
    {
      ingress_description                                = "allow ports TCP 30000-32767"
      ingress_from_port                                  = "30000"
      ingress_to_port                                    = "32767"
      ingress_protocol                                   = "tcp"
      ingress_cidr_blocks                                = ["10.0.0.0/20", "10.0.16.0/20"]
      ingress_ipv6_cidr_blocks                           = []
      ingress_prefix_list_ids                            = []
      ingress_self                                       = false
    }
  ]
  egress                                               = {
      egress_description                               = "allow all outbound to 0.0.0.0/0"
      egress_port                                      = "0"
      egress_protocol                                  = "-1"
      egress_cidr_blocks                               = [ "0.0.0.0/0" ]
  }
}