# This module depends on IAM Policy.
# Please set respective dependensies in root module!

data "aws_iam_policy" "iam_policy_arn" {
  name = var.iam_role.policy_name
}

resource "aws_iam_role" "this" {
    name               = var.iam_role.iam_role_name
    assume_role_policy = file(var.iam_role.trusted_entities_policy_file_path)
    tags               = merge(var.common_tags, {Name = "${var.iam_role.iam_role_name}"})
}

resource "aws_iam_role_policy_attachment" "this" {
    role               = aws_iam_role.this.name
    policy_arn         = data.aws_iam_policy.iam_policy_arn.arn
}
