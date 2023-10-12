resource "aws_subnet" "minor" {
  vpc_id                    = aws_vpc.major.id
  cidr_block                = var.cidr_block
  map_public_ip_on_launch   = var.public
  availability_zone         = var.av_zone

  tags = {
    Name                    = "${sub_name}"
  }
}