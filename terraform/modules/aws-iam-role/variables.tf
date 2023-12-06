
variable "iam_role" {
    description                           = "Specify trusted entities policy file path and policies arns that you want to apply to this role"
    type                                  = object({
        iam_role_name                     = string
        trusted_entities_policy_file_path = string
        policies_arn                      = list(string)
    })
  
}

variable "common_tags" {
    description                           = "Tags suitable for all resources"
    type                                  = map
}