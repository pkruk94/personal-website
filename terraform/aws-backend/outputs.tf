output "dns_deploy_role_arn" {
  value = aws_iam_role.github_actions_dns_record_deploy_role.arn
}

output "infra_apply_role_arn" {
  value = aws_iam_role.github_actions_infrastructure_apply_role.arn
}

output "infra_plan_role_arn" {
  value = aws_iam_role.github_actions_infrastructure_plan_role.arn
}

output "frontend_deploy_role_arn" {
  value = aws_iam_role.github_actions_frontend_deploy_role.arn
}

