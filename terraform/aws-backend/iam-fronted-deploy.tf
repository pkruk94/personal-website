module "frontend_deploy_role" {
  source = "../modules/github-actions-role"
  context = {
    role_name               = "GitHubActionsFrontendDeployRole"
    role_description        = "Role for GitHub Actions to deploy frontend assets"
    policy_name             = "GitHubActionsFrontendDeployPolicy"
    policy_description      = "Allows for updating S3 bucket and invalidating CloudFront cache."
    policy_json             = data.aws_iam_policy_document.deploy_frontend_permissions.json
    assume_role_policy_json = data.aws_iam_policy_document.oidc_apply_assume_role.json
    tags                    = local.module_tags
  }
}

data "aws_iam_policy_document" "deploy_frontend_permissions" {
  statement {
    sid    = "S3StaticContentManagement"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}-*",
      "arn:aws:s3:::${var.bucket_name}-*/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values = [local.project_tag]
    }
  }
  statement {
    sid    = "CloudFrontInvalidation"
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations",
      "cloudfront:GetDistribution"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values = [local.project_tag]
    }
  }
  statement {
    sid    = "CloudFrontList"
    effect = "Allow"
    actions = [
      "cloudfront:ListDistributions"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "SSMReadInfraParameters"
    effect = "Allow"
    actions = [
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/infra/*",
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/dns/*/cloudflare/*"
    ]
  }
}