# This module asks for PUBLIC KEY. 
# Do not describe public_key_contents variable in tfvars file, so you can enter it safely either on prompt after terraform plan/apply command or 
# add it to terraform enviroment variable before the launch by command: export TF_VAR_public_key_contents='your public key'

# This module depends on Subnets, Security Groups, RDS Instance (if applicapable), SSM Parameter (if applicapable).
# Please set respective dependensies in root module!

resource "aws_key_pair" "this" {
  key_name                    = var.ec2.public_key_name
  public_key                  = var.public_key_contents

  tags                        = merge(var.common_tags, {Name = "${var.ec2.public_key_name}"})
}

resource "aws_instance" "this" {
  ami                         = var.ec2.instance_parameters.instance_ami
  instance_type               = var.ec2.instance_parameters.instance_type
  subnet_id                   = data.aws_subnet.data.id
  associate_public_ip_address = var.ec2.instance_parameters.associate_public_ip_address
  vpc_security_group_ids      = local.sg_ids
  key_name                    = aws_key_pair.this.key_name
  user_data                   = var.ec2.rds_instance_parameters.gather_rds_instance_data ? templatefile(
                                                                                              "${var.ec2.instance_parameters.user_data_path}", 
                                                                                                {
                                                                                                  db_name = data.aws_db_instance.data[0].db_name,
                                                                                                  db_user = data.aws_db_instance.data[0].master_username,
                                                                                                  db_host = data.aws_db_instance.data[0].address,       
                                                                                                  db_pass = data.aws_ssm_parameter.data[0].value
                                                                                                  lb_host = data.aws_lb.data[0].dns_name
                                                                                                }
                                                                                            ) : "${file(var.ec2.instance_parameters.user_data_path)}"
  tags                        = merge(var.common_tags, {Name = "${var.ec2.instance_parameters.instance_name}"})
}