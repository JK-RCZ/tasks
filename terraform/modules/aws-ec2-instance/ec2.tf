# This module asks for PUBLIC KEY. 
# Do not describe public_key_contents variable in tfvars file, so you can enter it safely either on prompt after terraform plan/apply command or 
# add it to terraform enviroment variable before the launch by command: export TF_VAR_public_key_contents='your public key'

# This module depends on Subnets, Security Groups, RDS Instance (if applicapable), SSM Key (if applicapable), IAM Role (if applicapable).  
# Please set respective dependensies in root module!

resource "aws_key_pair" "this" {
  key_name                    = var.ec2.public_key_name
  public_key                  = var.public_key_contents

  tags                        = merge(var.common_tags, {Name = "${var.ec2.public_key_name}"})
}

resource "aws_iam_instance_profile" "this" {
  count = var.ec2.instance_profile_parameters.create_instance_profile ? 1 : 0
  name = var.ec2.instance_profile_parameters.instance_profile_name
  role = var.ec2.instance_profile_parameters.attach_role_name
}

resource "aws_instance" "this" {
  ami                         = var.ec2.instance_parameters.instance_ami
  instance_type               = var.ec2.instance_parameters.instance_type
  subnet_id                   = data.aws_subnet.subnet_id.id
  associate_public_ip_address = var.ec2.instance_parameters.associate_public_ip_address
  vpc_security_group_ids      = local.sg_ids
  iam_instance_profile        = var.ec2.instance_profile_parameters.create_instance_profile ? aws_iam_instance_profile.this[0].name : null
  key_name                    = aws_key_pair.this.key_name
  user_data                   = var.ec2.rds_instance_parameters.gather_rds_instance_data ? templatefile(
                                                                                              "${var.ec2.instance_parameters.user_data_path}", 
                                                                                                {
                                                                                                  db_name = data.aws_db_instance.db_credentials[0].db_name,
                                                                                                  db_user = data.aws_db_instance.db_credentials[0].master_username,
                                                                                                  db_host = data.aws_db_instance.db_credentials[0].address,       
                                                                                                  db_pass = data.aws_ssm_parameter.db_password[0].value
                                                                                                  lb_host = data.aws_lb.lb_dns_name[0].dns_name
                                                                                                }
                                                                                            ) : "${file(var.ec2.instance_parameters.user_data_path)}"
  tags                        = merge(var.common_tags, {Name = "${var.ec2.instance_parameters.instance_name}"})
}
