


resource "aws_key_pair" "ssh" {
  key_name   = var.ssh_key.name
  public_key = var.ssh_key.contents
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
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.dog.id]
  key_name = aws_key_pair.ssh.key_name
  tags = merge(var.common_tags, {Name = "${var.aws_instance.name}"})
  user_data = "${file(var.aws_instance.user_data_path)}"
}