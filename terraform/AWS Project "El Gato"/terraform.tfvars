
vpc_parameters = {
  region = "eu-west-2"
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name_tag = "Cat"
}

common_tags = {
    Environment = "Dev"
    Project = "El Gato"
}

subnets = [
    {
    name = "Private Subnet 1"
    public = "false"
    cidr_block = "10.0.0.0/18"
    availability_zone = "eu-west-2a"
    },
    {
    name = "Private Subnet 2"
    public = "false"
    cidr_block = "10.0.64.0/18"
    availability_zone = "eu-west-2b"
    },
    {
    name = "Public Subnet 1"
    public = "true"
    cidr_block = "10.0.128.0/18"
    availability_zone = "eu-west-2a"
    },
    {
    name = "Public Subnet 2"
    public = "true"
    cidr_block = "10.0.192.0/18"
    availability_zone = "eu-west-2b"
    }
]