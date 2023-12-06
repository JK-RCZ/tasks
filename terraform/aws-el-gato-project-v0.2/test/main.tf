provider "aws" {
    region = "eu-west-2"
  
}

resource "aws_iam_role" "test" {
    name = "test_role"
    assume_role_policy = file("../policies/trusted-entity-ec2-policy")
}

resource "aws_iam_role_policy_attachment" "uno" {
    role = aws_iam_role.test.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
}

resource "aws_iam_role_policy_attachment" "duo" {
    role = aws_iam_role.test.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_vpc" "test" {
    cidr_block = "10.0.0.0/20"
    instance_tenancy = "default"
  
}

resource "aws_subnet" "test" {
    vpc_id = aws_vpc.test.id
    cidr_block = "10.0.0.0/22"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-2a"
  
}

resource "aws_internet_gateway" "test" {
    vpc_id = aws_vpc.test.id
}

resource "aws_route_table" "test" {
  vpc_id                    = aws_vpc.test.id
  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.test.id
  }
  
}

resource "aws_route_table_association" "test" {
  subnet_id                 = aws_subnet.test.id
  route_table_id            = aws_route_table.test.id
}

resource "aws_security_group" "test" {
    name = "test_security"
    vpc_id = aws_vpc.test.id

   ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
}

variable "public_key_contents" {
  
}

resource "aws_key_pair" "test" {
  key_name                    = "gogi"
  public_key                  = var.public_key_contents
}

resource "aws_iam_instance_profile" "test" {
  name = "test_instance_profile"
  role = aws_iam_role.test.name
}

resource "aws_instance" "test" {
  
  ami = "ami-0b6384181e01b87fb"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.test.id
  associate_public_ip_address = "true"
  iam_instance_profile = aws_iam_instance_profile.test.name
  vpc_security_group_ids = [aws_security_group.test.id]
  key_name = "gogi"
  
  tags = {
    Name = "Terra1"
  }
  
}

resource "aws_kms_key" "test" {
  description              = "Test KMS Key"
  deletion_window_in_days  = 10
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
}

resource "aws_ebs_default_kms_key" "test" {
  key_arn = aws_kms_key.test.arn
}

resource "aws_ebs_encryption_by_default" "test" {
  enabled = true
}