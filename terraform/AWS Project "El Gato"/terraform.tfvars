
vpc_parameters = {
  region = "eu-west-2"
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name_tag = "Cat"
  internnet_gw_name_tag = "Porch"
}

common_tags = {
    Environment = "Dev"
    Project = "El Gato"
}

private_subnets = [
    {
    name = "Private Mouse 1"
    public = "false"
    cidr_block = "10.0.0.0/18"
    availability_zone = "eu-west-2a"
    },
    {
    name = "Private Mouse 2"
    public = "false"
    cidr_block = "10.0.64.0/18"
    availability_zone = "eu-west-2b"
    }
]

public_subnets = [ 
    {
    name = "Public Mouse 1"
    public = "true"
    cidr_block = "10.0.128.0/18"
    availability_zone = "eu-west-2a"
    },
    {
    name = "Public Mouse 2"
    public = "true"
    cidr_block = "10.0.192.0/18"
    availability_zone = "eu-west-2b"
    }
]


security_group = [ "22", "80" ]

vpc_name = "Cat"
subnet_name = "Private Mouse 1"
public_subnets_ids = ["Public Mouse 1", "Public Mouse 2"]

aws_instance =  {
  name = "in1"
  associate_public_ip_address = "false"
  ami =  "ami-0b6384181e01b87fb" # Amazon  # SUSE "ami-029b760a1ef7c0528"
  instance_type = "t2.micro"
  user_data_path = "install-LAMP.sh"
}

