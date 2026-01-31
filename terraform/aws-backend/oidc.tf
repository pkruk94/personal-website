resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = {
    Environment = var.environment
    ManagedBy = "terraform-bootstrap"
  }
}

data "aws_iam_policy_document" "oidc_plan_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      identifiers = [aws_iam_openid_connect_provider.github.arn]
      type        = "Federated"
    }
    condition {
      test     = "StringLike"
      values   = ["repo:pkruk94/personal-website:*"]
      variable = "token.actions.githubusercontent.com:sub"
    }
    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }
  }
}

data "aws_iam_policy_document" "oidc_apply_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"
    principals {
      identifiers = [aws_iam_openid_connect_provider.github.arn]
      type = "Federated"
    }
    condition {
      test     = "StringEquals"
      values = ["repo:pkruk94/personal-website:ref:refs/heads/main"]
      variable = "token.actions.githubusercontent.com:sub"
    }
    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }
  }
}

data "aws_iam_policy_document" "oidc_dns_record_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"
    principals {
      identifiers = [aws_iam_openid_connect_provider.github.arn]
      type = "Federated"
    }
    condition {
      test     = "StringLike"
      values   = ["repo:pkruk94/my-portfolio:*"]
      variable = "token.actions.githubusercontent.com:sub"
    }
    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }
  }
}

