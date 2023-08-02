provider "aws" {
   region = "us-east-1"

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
    cidr_blocks      = ["37.214.81.103/32"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["37.214.81.103/32"]
  }
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["37.214.81.103/32"]
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

  tags = {
    Name = "TerraSUSE2"
  }
  
}


