# This module depends on VPC and Security groups(if inbound traffic alloud only from existing security groups).
# Please set respective dependensies in root module!

resource "aws_security_group" "this" {
  name                         = var.security_group.sg_name
  description                  = var.security_group.sg_descritption
  vpc_id                       = data.aws_vpc.vpc_id.id
  
  dynamic "ingress" {
    for_each                   = toset(var.security_group.ingress)
    content {
        description            = ingress.value ["ingress_description"]
        from_port              = ingress.value ["ingress_port"]
        to_port                = ingress.value ["ingress_port"]
        protocol               = ingress.value ["ingress_protocol"]
        cidr_blocks            = ingress.value ["ingress_cidr_blocks"]
        ipv6_cidr_blocks       = ingress.value ["ingress_ipv6_cidr_blocks"]
        prefix_list_ids        = ingress.value ["ingress_prefix_list_ids"]
        self                   = ingress.value ["ingress_self"]
        security_groups        = local.sg_ids
    }
  }
  egress {
    from_port                  = var.security_group.egress.egress_port
    to_port                    = var.security_group.egress.egress_port
    protocol                   = var.security_group.egress.egress_protocol
    cidr_blocks                = var.security_group.egress.egress_cidr_blocks
  }
  
  tags                         = merge(var.common_tags, {Name = "${var.security_group.sg_name}"})
}

