data "aws_iam_policy_document" "deploy_infrastructure_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
      "cloudfront:*",
      "lambda:*",
      "apigateway:*",
      "logs:*",
      "dynamodb:*",
      "cloudwatch:*",
      "acm:*",
      "iam:GetRole",
      "iam:PassRole"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "deploy_frontend_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListObject",
      "s3:GetObject",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}-*",
      "arn:aws:s3:::${var.bucket_name}-*/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations",
      "cloudfront:GetDistribution",
      "cloudfront:ListDistributions"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "deploy_infrastructure_policy" {
  name        = "GitHubActionsInfrastructureDeployPolicy"
  description = "Allows for creating infrastructure for my personal website project."
  policy      = data.aws_iam_policy_document.deploy_infrastructure_permissions.json
}

resource "aws_iam_policy" "deploy_frontend_policy" {
  name        = "GitHubActionFrontEndDeployPolicy"
  description = "Allows for updating S3 bucket and invalidating CloudFront cache."
  policy      = data.aws_iam_policy_document.deploy_frontend_permissions.json
}