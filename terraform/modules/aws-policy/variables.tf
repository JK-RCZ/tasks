
variable "iam_policy" {
    description                          = "IAM policy main parameters"
    type                                 = object({
      policy_name                        = string
      policy_path                        = string
      policy_json_file_path              = string
    })
}

variable "common_tags" {
    description                          = "Tags suitable for all resources"
    type                                 = map
}