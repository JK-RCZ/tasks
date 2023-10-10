provider "aws" {
   region = local.region

}

#------------------------------------------ LOCAL VARIABLES ----------------------------------------
locals {
  region              = "eu.west.2"
  av_zone_1           = "eu.west.2a"
  av_zone_2           = "eu.west.2b"
  vpc_cidr_block      = "10.0.0.0/16"     # net 
  public1_cidr_block  = "10.0.0.0/18"     # subnet #1 
  private1_cidr_block = "10.0.64.0/18"    # subnet #2 
  public2_cidr_block  = "10.0.128.0/18"   # subnet #3 
  private2_cidr_block = "10.0.192.0/18"   # subnet #4     
}

#------------------------------------ CREATING VPC & FOUR SUBNETS ---------------------------------
resource "aws_vpc" "terra-dev-env-net" {
  cidr_block       = local.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "terra-dev-env-net"
  }
}

resource "aws_subnet" "terra-dev-env-public1-subnet" {
  vpc_id     = aws_vpc.terra-dev-env-net.id
  cidr_block = local.public1_cidr_block
  map_public_ip_on_launch = "true"
  availability_zone = local.av_zone_1

  tags = {
    Name = "terra-dev-env-public1-subnet"
  }
}
resource "aws_subnet" "terra-dev-env-private1-subnet" {
  vpc_id     = aws_vpc.terra-dev-env-net.id
  cidr_block = local.private1_cidr_block
  map_public_ip_on_launch = "false"
  availability_zone = local.av_zone_1

  tags = {
    Name = "terra-dev-env-private1-subnet"
  }
}

resource "aws_subnet" "terra-dev-env-public2-subnet" {
  vpc_id     = aws_vpc.terra-dev-env-net.id
  cidr_block = local.public2_cidr_block
  map_public_ip_on_launch = "true"
  availability_zone = local.av_zone_2

  tags = {
    Name = "terra-dev-env-public2-subnet"
  }
}
resource "aws_subnet" "terra-dev-env-private2-subnet" {
  vpc_id     = aws_vpc.terra-dev-env-net.id
  cidr_block = local.private2_cidr_block
  map_public_ip_on_launch = "false"
  availability_zone = local.av_zone_2

  tags = {
    Name = "terra-dev-env-private2-subnet"
  }
}

#------------------------------------ CREATING INTERNET GATEWAY ---------------------------------
resource "aws_internet_gateway" "terra-dev-env-igw" {
  vpc_id     = aws_vpc.terra-dev-env-net.id
  tags = {
    Name = "terra-dev-env-igw"
  }
}