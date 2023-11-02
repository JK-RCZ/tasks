


resource "aws_key_pair" "ssh" {
  key_name   = "key"
  public_key = var.public-key
  tags = var.common_tags
}

resource "aws_security_group" "dog" {
  description = "Allow inbound/outbound traffic"
  vpc_id      = var.vpc_id
    
  dynamic "ingress" {
    for_each = toset(var.security_group.ports)
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {Name = "${var.security_group.name}"})
}

resource "aws_security_group" "rds-ec2" {
  description = "Allow inbound traffic from ec2"
  vpc_id      = var.vpc_id
  ingress     = [{
    description            = "mariaDB"
    from_port              = 3306
    to_port                = 3306
    protocol               = "tcp"
    cidr_blocks            = ["0.0.0.0/0"]
    ipv6_cidr_blocks       = []
    prefix_list_ids        = []
    self                   = "false"
    security_groups        = [aws_security_group.dog.id]
  }]
  egress                   = []
  tags                     = var.common_tags
}

resource "aws_instance" "entity" {
  
  ami = var.aws_instance.ami
  instance_type = var.aws_instance.instance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = var.aws_instance.associate_public_ip_address
  vpc_security_group_ids = [aws_security_group.dog.id]
  key_name = aws_key_pair.ssh.key_name
  tags = merge(var.common_tags, {Name = "${var.aws_instance.name}"})
  user_data = "${file(var.aws_instance.user_data_path)}"
}

resource "aws_lb" "multi-pulti" {
  count = var.aws_instance.associate_public_ip_address ? 0 : 1
  name               = "Spider"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.dog.id]
  subnets            = var.public_subnets_ids
  
  enable_deletion_protection = false

  tags = var.common_tags
}

resource "aws_lb_target_group" "target-locked" {
  count = var.aws_instance.associate_public_ip_address ? 0 : 1
  name     = "aim"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"
  tags = var.common_tags
  
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.target-locked[0].arn
  target_id        = aws_instance.entity.id
  port             = 80
  
  
}

resource "aws_lb_listener" "target-locked_multi-pulti" {
  count = var.aws_instance.associate_public_ip_address ? 0 : 1
  load_balancer_arn = aws_lb.multi-pulti[0].id
  port = 80
  protocol = "HTTP"
  tags = var.common_tags
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-locked[0].id
  }
}

resource "aws_db_subnet_group" "lamp-db" {
  name = var.rds_instance.rds_instance_name
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, {Name = "${var.rds_instance.rds_instance_name}"})
}

resource "aws_db_parameter_group" "lamp-db" {
  family = var.db-parameter-group
  tags = merge(var.common_tags, {Name = "${var.rds_instance.rds_instance_name}"})

  #parameter {
  #  name  = "log_connections"
  #  value = "1"
  #}
}

resource "aws_db_instance" "lamp-db" {
  allocated_storage    = var.rds_instance.allocated_storage
  storage_type         = var.rds_instance.storage_type
  db_name              = var.rds_instance.db_name
  engine               = var.rds_instance.engine
  engine_version       = var.rds_instance.engine_version
  instance_class       = var.rds_instance.instance_class
  username             = var.rds_instance.username
  password             = var.rds_instance.password
  parameter_group_name = aws_db_parameter_group.lamp-db.name
  skip_final_snapshot  = var.rds_instance.skip_final_snapshot
  db_subnet_group_name   = aws_db_subnet_group.lamp-db.name
  vpc_security_group_ids = [aws_security_group.rds-ec2.id] 
  publicly_accessible    = var.rds_instance.publicly_accessible
  

  tags = merge(var.common_tags, {Name = "${var.rds_instance.rds_instance_name}"})
}
