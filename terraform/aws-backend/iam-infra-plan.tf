module "infra_plan_role" {
  source = "../modules/github-actions-role"
  context = {
    role_name               = "GitHubActionsInfrastructurePlanRole"
    role_description        = "Role for GitHub Actions to run terraform plan"
    policy_name             = "GitHubActionsInfrastructurePlanPolicy"
    policy_description      = "Read-only access for terraform plan"
    policy_json             = data.aws_iam_policy_document.plan_infrastructure_permissions.json
    assume_role_policy_json = data.aws_iam_policy_document.oidc_plan_assume_role.json
    tags                    = local.module_tags
  }
}

data "aws_iam_policy_document" "plan_infrastructure_permissions" {
  statement {
    sid    = "S3ReadOnly"
    effect = "Allow"
    actions = [
      "s3:GetBucket*",
      "s3:GetObject",
      "s3:GetEncryptionConfiguration",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}-*",
      "arn:aws:s3:::${var.bucket_name}-*/*"
    ]
  }
  statement {
    sid    = "DynamoDBReadOnly"
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:DescribeContinuousBackups",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource"
    ]
    resources = [
      "arn:aws:dynamodb:${local.region}:${local.account_id}:table/SiteStatistics-*"
    ]
  }
  statement {
    sid    = "LambdaReadOnly"
    effect = "Allow"
    actions = [
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:GetPolicy",
      "lambda:ListTags",
      "lambda:ListVersionsByFunction"
    ]
    resources = [
      "arn:aws:lambda:${local.region}:${local.account_id}:function:VisitCounterLambda-*"
    ]
  }
  statement {
    sid    = "APIGatewayReadOnly"
    effect = "Allow"
    actions = [
      "apigateway:GET"
    ]
    resources = [
      "arn:aws:apigateway:${local.region}::/apis/*",
      "arn:aws:apigateway:${local.region}::/tags/*"
    ]
  }
  statement {
    sid    = "CloudFrontReadOnly"
    effect = "Allow"
    actions = [
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:ListDistributions",
      "cloudfront:ListTagsForResource"
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
      "cloudfront:ListDistributions",
      "cloudfront:ListOriginAccessControls"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "ACMReadOnly"
    effect = "Allow"
    actions = [
      "acm:DescribeCertificate",
      "acm:GetCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values = [local.project_tag]
    }
  }
  statement {
    sid    = "ACMList"
    effect = "Allow"
    actions = [
      "acm:ListCertificates"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "CloudWatchLogsReadOnly"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:ListTagsLogGroup"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/VisitCounterLambda-*"
    ]
  }
  statement {
    sid    = "SSMReadOnly"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListTagsForResource"
    ]
    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/infra/*",
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/dns/*"
    ]
  }
  statement {
    sid    = "IAMReadOnly"
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListRoleTags",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies"
    ]
    resources = [
      "arn:aws:iam::${local.account_id}:role/LambdaUpdateCounterRole-*"
    ]
  }
  statement {
    sid    = "TerraformStateReadOnly"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::personal-website-tf-state",
      "arn:aws:s3:::personal-website-tf-state/*"
    ]
  }
  statement {
    sid    = "TerraformStateLockingReadOnly"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem"
    ]
    resources = [
      "arn:aws:dynamodb:${local.region}:${local.account_id}:table/terraform-state-locking"
    ]
  }
}