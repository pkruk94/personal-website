resource "aws_iam_policy" "this" {
  name        = var.context.policy_name
  description = var.context.policy_descrition
  policy      = var.context.policy_json

  tags = var.context.tags
}

resource "aws_iam_role" "this" {
  name               = var.context.role_name
  description        = var.context.role_description
  assume_role_policy = var.context.assume_role_policy_json

  tags = var.context.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}