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
      "iam:PassRole",
      "ssm:GetParameter"
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
      "s3:ListBucket",
      "ssm:GetParameter"
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

data "aws_iam_policy_document" "plan_infrastructure_permission" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
      "cloudfront:Get*",
      "cloudfront:List*",
      "lambda:Get*",
      "lambda:List*",
      "apigateway:GET",
      "logs:Describe*",
      "logs:Get*",
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "acm:Describe*",
      "acm:Get*",
      "acm:List*",
      "iam:GetRole",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "ssm:GetParameter"
    ]
    resources = ["*"]
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "deploy_dns_record" {
  statement {
    effect = "Allow"
    actions = ["ssm:GetParameter"]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/dns/prod/cloudflare/*",
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/infra/prod/cloudfront/domain_name"
    ]
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

resource "aws_iam_policy" "plan_infrastructure_policy" {
  name = "GitHubActionsInfrastructurePlanPolicy"
  description = "Read-only access for terraform plan"
  policy = data.aws_iam_policy_document.plan_infrastructure_permission.json
}

resource "aws_iam_policy" "deploy-dns-record" {
  name = "GitHubActionsDeployDnsRecordPolicy"
  description = "Retrieve necessary parameters for CloudFlare from SSM"
  policy = data.aws_iam_policy_document.deploy_dns_record.json
}