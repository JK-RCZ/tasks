provider "aws" {
   region = var.region

}


module "dev-vpc" {
  source = "../modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  tags = merge(var.common_tags, {Name = "Cat"})
  
}

/*module "private" {
    source = "../modules/subnet"
    count = length(local.av_zone)
    av_zone = "${count.index}"
    sub_name = "${count.index}_private"
    cidr_block = local.private_subnet_cidr
    public = "false"
}*/

  
