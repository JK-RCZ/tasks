variable "region" {
    default = "eu-west-2"
}
variable "av_zone_1" {
    default = "eu-west-2a"
}
variable "av_zone_2" {
    default = "eu-west-2b"
}
variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}
variable "public1_cidr_block" {
    default = "10.0.0.0/18"
}
variable "private1_cidr_block" {
    default = "10.0.64.0/18"
}
variable "public2_cidr_block" {
    default = "10.0.128.0/18"
}
variable "private2_cidr_block" {
    default = "10.0.192.0/18"
}