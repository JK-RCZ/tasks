
resource "aws_iam_policy" "this" {
  name        = var.iam_policy.policy_name
  path        = var.iam_policy.policy_path
  policy      = "${file(var.iam_policy.policy_json_file_path)}"
  tags        = merge(var.common_tags, {Name = "${var.iam_policy.policy_name}"})
}