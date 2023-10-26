


resource "aws_key_pair" "ssh" {
  key_name   = "key"
  public_key = var.public-key
}

resource "aws_security_group" "dog" {
  description = "Allow inbound/outbound traffic"
  vpc_id      = var.vpc_id
    
  dynamic "ingress" {
    for_each = toset(var.security_group)
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

  tags = merge(var.common_tags, {Name = "Straight Security"})

  
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
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-locked[0].id
  }
}


