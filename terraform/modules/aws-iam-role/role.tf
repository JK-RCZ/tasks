
resource "aws_iam_role" "this" {
    name               = var.iam_role.iam_role_name
    assume_role_policy = file(var.iam_role.trusted_entities_policy_file_path)
    tags               = merge(var.common_tags, {Name = "${var.iam_role.iam_role_name}"})
}

resource "aws_iam_role_policy_attachment" "this" {
    count              = length(var.iam_role.policies_arn)
    role               = aws_iam_role.this.name
    policy_arn         = var.iam_role.policies_arn[count.index]
}
