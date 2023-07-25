provider "aws" {

}
    
resource "aws_instance" "terrasuse" {
    count = 1
    ami = "ami-07dff4fe919dee33e"
    instance_type = "t2.micro"
    tags = {
        Name ="Terra-SUSE"
    }
  
}
