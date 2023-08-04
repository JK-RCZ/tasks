provider "aws" {
   region = "us-east-1"

}
variable "local_public_IP" {
  type = string
  sensitive = false
  default = "0.0.0.0"
}
#------------------------------------------- NULL RESOURCE -----------------------------------------
resource "null_resource" "get-local-public-ip" {

  provisioner "local-exec" {
    command = <<EOT
                curl ipconfig.io > ~/Keys-tokens-etc/local-public-ip
              EOT
  }
}
