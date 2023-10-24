
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

ssh_key = {
  name = "jan2"
  contents = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCGxBdCOoCWhvgw75SKLoHIU5jnhAb+2Wdp6SBdKNZY/2M+mMt+VvLS8mXq07x+7GjYiA/iNpoA+tWWYB4yrWiX7vnAksZBaaU4q07dbcrV+i2FX6XR7lAgI8llq9qc9xcacgZxe6g14uFViJwVtsId+geUOZDRYcy4zfO0aSMXEPGaEAeo0aeFKKojP+LeRRuh0/rQj2fNjgxZL8AKdiZrDy30S6XIlj9ZutCvufa/2Z1GRjcHEHUml8Ylsyr2886q9CjTS/cQbqd2PfqcgqTA4B9ntO6en3ZgHhufr/zD3ZVNOABkuA8fDs6DwNFJ9rHBc5B7/mbnWL+PtYIfvRCN"
}

security_group = [ "22", "80" ]

aws_instance =  {
  name = "in1"
  ami = "ami-029b760a1ef7c0528"
  instance_type = "t2.micro"
  user_data_path = "install-LAMP.sh"
}

vpc_name = "Cat"
subnet_name = "Public Mouse 1"