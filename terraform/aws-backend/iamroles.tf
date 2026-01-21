resource "aws_iam_role" "github-actions-infrastructure-deploy-role" {
  name               = "GitHubActionsInfrastructureDeployRole"
  assume_role_policy = data.aws_iam_policy_document.oidc_apply_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_infrastructure_policy_attachment" {
  policy_arn = aws_iam_policy.deploy_infrastructure_policy.arn
  role       = aws_iam_role.github-actions-infrastructure-deploy-role.name
}

resource "aws_iam_role" "github-actions-frontend-deploy-role" {
  name               = "GitHubActionsFrontendDeployRole"
  assume_role_policy = data.aws_iam_policy_document.oidc_apply_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_frontend_policy_attachment" {
  policy_arn = aws_iam_policy.deploy_frontend_policy.arn
  role       = aws_iam_role.github-actions-frontend-deploy-role.name
}

resource "aws_iam_role" "github-actions-infrastructure-plan-role" {
  name = "GitHubActionsInfrastructurePlanRole"
  assume_role_policy = data.aws_iam_policy_document.oidc_plan_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions_plan_policy_attachment" {
  policy_arn = aws_iam_policy.plan_infrastructure_policy.arn
  role = aws_iam_role.github-actions-infrastructure-plan-role.name
}