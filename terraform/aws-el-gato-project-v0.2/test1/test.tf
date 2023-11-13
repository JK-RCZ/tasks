

resource "terraform_data" "export_rds_endpoint" {
  provisioner "local-exec" {
    command                = "echo LOS > temp.txt"
  }
  
}

resource "terraform_data" "launch_inject_script" {
  triggers_replace         = [timestamp()]
  provisioner "local-exec" {
    command                = "./inject-parameters-in-containers.sh"
  }
  depends_on               = [ resource.terraform_data.export_rds_endpoint ]
}