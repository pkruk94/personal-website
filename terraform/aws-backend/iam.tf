locals {
  project_tag = "personal-website"
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name

  module_tags = local.common_tags
}

# Infrastructure Apply Role

module "infra_apply_role" {
  source = "../modules/github-actions-role"

  role_name               = "GitHubActionsInfrastructureApplyRole"
  role_description        = "Role for GitHub Actions to apply infrastructure changes"
  policy_name             = "GitHubActionsInfrastructureApplyPolicy"
  policy_description      = "Allows for creating infrastructure for my personal website project."
  policy_json             = data.aws_iam_policy_document.apply_infrastructure_permissions.json
  assume_role_policy_json = data.aws_iam_policy_document.oidc_apply_assume_role.json
  tags                    = local.module_tags
}

data "aws_iam_policy_document" "apply_infrastructure_permissions" {
  statement {
    sid    = "S3CreateAndTag"
    effect = "Allow"
    actions = [
      "s3:CreateBucket",
      "s3:PutBucketTagging",
      "s3:PutBucketVersioning",
      "s3:PutBucketPublicAccessBlock",
      "s3:PutEncryptionConfiguration",
      "s3:PutBucketPolicy"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}-*"
    ]
  }
  statement {
    sid    = "S3ModifyAndDelete"
    effect = "Allow"
    actions = [
      "s3:DeleteBucket",
      "s3:DeleteBucketPolicy",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetBucketPolicy",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:GetBucketTagging",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketPublicAccessBlock",
      "s3:ListBucket",
      "s3:ListBucketVersions"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}-*",
      "arn:aws:s3:::${var.bucket_name}-*/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [local.project_tag]
    }
  }
  statement {
    sid    = "DynamoDBCreateAndTag"
    effect = "Allow"
    actions = [
      "dynamodb:CreateTable",
      "dynamodb:TagResource"
    ]
    resources = [
      "arn:aws:dynamodb:${local.region}:${local.account_id}:table/SiteStatistics-*"
    ]
  }
  statement {
    sid    = "DynamoDBModifyAndDelete"
    effect = "Allow"
    actions = [
      "dynamodb:DeleteTable",
      "dynamodb:UpdateTable",
      "dynamodb:DescribeTable",
      "dynamodb:DescribeContinuousBackups",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:UntagResource"
    ]
    resources = [
      "arn:aws:dynamodb:${local.region}:${local.account_id}:table/SiteStatistics-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [local.project_tag]
    }
  }
  statement {
    sid    = "LambdaCreateAndTag"
    effect = "Allow"
    actions = [
      "lambda:CreateFunction",
      "lambda:TagResource"
    ]
    resources = [
      "arn:aws:lambda:${local.region}:${local.account_id}:function:VisitCounterLambda-*"
    ]
  }
  statement {
    sid    = "LambdaModifyAndDelete"
    effect = "Allow"
    actions = [
      "lambda:DeleteFunction",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:GetPolicy",
      "lambda:ListTags",
      "lambda:ListVersionsByFunction",
      "lambda:AddPermission",
      "lambda:RemovePermission",
      "lambda:UntagResource"
    ]
    resources = [
      "arn:aws:lambda:${local.region}:${local.account_id}:function:VisitCounterLambda-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [local.project_tag]
    }
  }
  statement {
    sid    = "APIGatewayCreateAndTag"
    effect = "Allow"
    actions = [
      "apigateway:POST",
      "apigateway:PUT",
      "apigateway:TagResource"
    ]
    resources = [
      "arn:aws:apigateway:${local.region}::/apis",
      "arn:aws:apigateway:${local.region}::/apis/*"
    ]
  }
  statement {
    sid    = "APIGatewayModifyAndDelete"
    effect = "Allow"
    actions = [
      "apigateway:DELETE",
      "apigateway:PATCH",
      "apigateway:GET"
    ]
    resources = [
      "arn:aws:apigateway:${local.region}::/apis/*",
      "arn:aws:apigateway:${local.region}::/tags/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [local.project_tag]
    }
  }
  statement {
    sid    = "CloudFrontCreateAndTag"
    effect = "Allow"
    actions = [
      "cloudfront:CreateDistribution",
      "cloudfront:CreateDistributionWithTags",
      "cloudfront:CreateOriginAccessControl",
      "cloudfront:TagResource"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "CloudFrontModifyAndDelete"
    effect = "Allow"
    actions = [
      "cloudfront:DeleteDistribution",
      "cloudfront:DeleteOriginAccessControl",
      "cloudfront:UpdateDistribution",
      "cloudfront:UpdateOriginAccessControl",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:ListTagsForResource",
      "cloudfront:UntagResource"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [local.project_tag]
    }
  }
  statement {
    sid    = "ACMCreateAndTag"
    effect = "Allow"
    actions = [
      "acm:RequestCertificate",
      "acm:AddTagsToCertificate"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "ACMModifyAndDelete"
    effect = "Allow"
    actions = [
      "acm:DeleteCertificate",
      "acm:DescribeCertificate",
      "acm:GetCertificate",
      "acm:ListTagsForCertificate",
      "acm:RemoveTagsFromCertificate"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [local.project_tag]
    }
  }
  statement {
    sid    = "CloudWatchLogsCreateAndTag"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:TagLogGroup",
      "logs:PutRetentionPolicy"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/VisitCounterLambda-*"
    ]
  }
  statement {
    sid    = "CloudWatchLogsModifyAndDelete"
    effect = "Allow"
    actions = [
      "logs:DeleteLogGroup",
      "logs:DescribeLogGroups",
      "logs:ListTagsLogGroup",
      "logs:UntagLogGroup"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/VisitCounterLambda-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [local.project_tag]
    }
  }
  statement {
    sid    = "SSMCreateAndTag"
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:AddTagsToResource"
    ]
    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/infra/*",
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/dns/*"
    ]
  }
  statement {
    sid    = "SSMReadAndDelete"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:DeleteParameter",
      "ssm:ListTagsForResource",
      "ssm:RemoveTagsFromResource"
    ]
    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/infra/*",
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/dns/*"
    ]
  }
  statement {
    sid    = "IAMRoleManagement"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:PassRole",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:ListRoleTags",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies"
    ]
    resources = [
      "arn:aws:iam::${local.account_id}:role/LambdaUpdateCounterRole-*"
    ]
  }
  statement {
    sid    = "TerraformStateAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::personal-website-tf-state",
      "arn:aws:s3:::personal-website-tf-state/*"
    ]
  }
  statement {
    sid    = "TerraformStateLocking"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [
      "arn:aws:dynamodb:${local.region}:${local.account_id}:table/terraform-state-locking"
    ]
  }
}

# Infrastructure Plan Role

module "infra_plan_role" {
  source = "../modules/github-actions-role"

  role_name               = "GitHubActionsInfrastructurePlanRole"
  role_description        = "Role for GitHub Actions to run terraform plan"
  policy_name             = "GitHubActionsInfrastructurePlanPolicy"
  policy_description      = "Read-only access for terraform plan"
  policy_json             = data.aws_iam_policy_document.plan_infrastructure_permissions.json
  assume_role_policy_json = data.aws_iam_policy_document.oidc_plan_assume_role.json
  tags                    = local.module_tags
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
      values   = [local.project_tag]
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
      values   = [local.project_tag]
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

# Frontend Deploy Role

module "frontend_deploy_role" {
  source = "../modules/github-actions-role"

  role_name               = "GitHubActionsFrontendDeployRole"
  role_description        = "Role for GitHub Actions to deploy frontend assets"
  policy_name             = "GitHubActionsFrontendDeployPolicy"
  policy_description      = "Allows for updating S3 bucket and invalidating CloudFront cache."
  policy_json             = data.aws_iam_policy_document.deploy_frontend_permissions.json
  assume_role_policy_json = data.aws_iam_policy_document.oidc_apply_assume_role.json
  tags                    = local.module_tags
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
      values   = [local.project_tag]
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
      values   = [local.project_tag]
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

# DNS Record Deploy Role

module "dns_deploy_role" {
  source = "../modules/github-actions-role"

  role_name               = "GitHubActionsDnsRecordDeployRole"
  role_description        = "Role for GitHub Actions to manage DNS records"
  policy_name             = "GitHubActionsDeployDnsRecordPolicy"
  policy_description      = "Retrieve necessary parameters for CloudFlare from SSM"
  policy_json             = data.aws_iam_policy_document.deploy_dns_record_permissions.json
  assume_role_policy_json = data.aws_iam_policy_document.oidc_dns_record_assume_role.json
  tags                    = local.module_tags
}

data "aws_iam_policy_document" "deploy_dns_record_permissions" {
  statement {
    sid    = "SSMReadDnsParameters"
    effect = "Allow"
    actions = [
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/dns/prod/cloudflare/*",
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/infra/prod/cloudfront/domain_name"
    ]
  }
}
