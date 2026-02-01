module "dns_deploy_role" {
  source = "../modules/github-actions-role"
  context = {
    role_name               = "GitHubActionsDnsRecordDeployRole"
    role_description        = "Role for GitHub Actions to manage DNS records"
    policy_name             = "GitHubActionsDeployDnsRecordPolicy"
    policy_description      = "Retrieve necessary parameters for CloudFlare from SSM"
    policy_json             = data.aws_iam_policy_document.deploy_dns_record_permissions.json
    assume_role_policy_json = data.aws_iam_policy_document.oidc_dns_record_assume_role.json
    tags                    = local.module_tags
  }
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
