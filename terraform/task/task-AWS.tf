provider "aws" {
   region = "us-east-1"

}
variable "sudo_pass" {
  type = string
  description = "Sudo password for some file operations."

  sensitive = true
}
variable "ssh_key_path" {
  type = string
  sensitive = false
  default = "~/Keys-tokens-etc/"
}
variable "ssh_key_name" {
  type = string
  sensitive = false
  default = "aws-key.pem"
}
variable "local_public_IP" {
  type = string
  sensitive = false
  default = "0.0.0.0"
}
#------------------------------------------- NULL RESOURCE -----------------------------------------
resource "null_resource" "set-permissions-666-to-ssh-key" {

  provisioner "local-exec" {
    command = <<EOT
                touch ${var.ssh_key_path}${var.ssh_key_name}
                echo ${var.sudo_pass} | sudo -S chmod 666 ${var.ssh_key_path}${var.ssh_key_name}
              EOT
  }
}

resource "null_resource" "get-local-public-ip" {

  provisioner "local-exec" {
    command = <<EOT
                curl ipconfig.io > ${var.ssh_key_path}local-public.ip
              EOT
  }
}

#------------------------------------ CREATING VPC & THREE SUBNETS ---------------------------------
resource "aws_vpc" "terra-task" {
  cidr_block       = "10.0.0.0/26"
  instance_tenancy = "default"

  tags = {
    Name = "terra-task"
  }
}

resource "aws_subnet" "terra-task-public1" {
  vpc_id     = aws_vpc.terra-task.id
  cidr_block = "10.0.0.0/28"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terra-task-public1"
  }
}
resource "aws_subnet" "terra-task-public2" {
  vpc_id     = aws_vpc.terra-task.id
  cidr_block = "10.0.0.16/28"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"

  tags = {
    Name = "terra-task-public2"
  }
}
resource "aws_subnet" "terra-task-private" {
  vpc_id     = aws_vpc.terra-task.id
  cidr_block = "10.0.0.32/28"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terra-task-private"
  }
}


#------------------------ CREATING SECURITY GROUP TO ALLOW SSH HTTP HTTPS --------------------------
resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow SSH, HTTP, HTTPS inbound traffic/All outbound traffic"
  vpc_id      = aws_vpc.terra-task.id
  

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["37.214.57.223/32"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["37.214.57.223/32"]
  }
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["37.214.57.223/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}


#------------------------------------ CREATING AWS INSTANCE ---------------------------------
resource "aws_instance" "Terra-SUSE1" {
  count = 1
  ami = "ami-07dff4fe919dee33e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.terra-task-public1.id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name = aws_key_pair.jan.key_name
  tags = {
    Name = "TerraSUSE1"
  }
  
}
resource "aws_instance" "Terra-SUSE2" {
  count = 1
  ami = "ami-07dff4fe919dee33e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.terra-task-public2.id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name = aws_key_pair.jan.key_name
  tags = {
    Name = "TerraSUSE2"
  }
  
}

#---------------------------------------- CREATING KEY PAIR -------------------------------------
resource "tls_private_key" "task-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "jan" {
  key_name = "aws-key"
  public_key = tls_private_key.task-key.public_key_openssh
  
  provisioner "local-exec" {
    command = "echo '${tls_private_key.task-key.private_key_pem}' > ${var.ssh_key_path}${var.ssh_key_name}"
  }
  provisioner "local-exec" {
    command = "chmod 400 ${var.ssh_key_path}${var.ssh_key_name}"
  }
  depends_on = [
        null_resource.set-permissions-666-to-ssh-key
  ]
}

#------------------------------------ CREATING INTERNET GATEWAY ---------------------------------
resource "aws_internet_gateway" "task-igw" {
  vpc_id     = aws_vpc.terra-task.id
  tags = {
    Name = "task-igw"
  }
}

#-------------------------------------- CREATING ROUTE TABLE -----------------------------------
resource "aws_route_table" "task-route-table" {
  vpc_id = aws_vpc.terra-task.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.task-igw.id
  }
  tags = {
    Name = "task-route-table"
  }
}
resource "aws_route_table_association" "terra-task-public1-association" {
  subnet_id      = aws_subnet.terra-task-public1.id
  route_table_id = aws_route_table.task-route-table.id
}
resource "aws_route_table_association" "terra-task-public2-association" {
  subnet_id      = aws_subnet.terra-task-public2.id
  route_table_id = aws_route_table.task-route-table.id
}

#-------------------------------------- OUTPUT EC2 IP's -----------------------------------
output "Terra-SUSE1-public-IP" {
  value = aws_instance.Terra-SUSE1.*.public_ip
}
output "Terra-SUSE2-public-IP" {
  value = aws_instance.Terra-SUSE2.*.public_ip
}
output "SSH-key-path" {
  value = var.ssh_key_path
}
output "Local-public-IP" {
  value = file("${var.ssh_key_path}local-public.ip")
}


