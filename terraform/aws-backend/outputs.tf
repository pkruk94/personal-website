output "dns_deploy_role_arn" {
  description = "ARN of the DNS deploy role"
  value       = module.dns_deploy_role.role_arn
}

output "infra_apply_role_arn" {
  description = "ARN of the infrastructure apply role"
  value       = module.infra_apply_role.role_arn
}

output "infra_plan_role_arn" {
  description = "ARN of the infrastructure plan role"
  value       = module.infra_plan_role.role_arn
}

output "frontend_deploy_role_arn" {
  description = "ARN of the frontend deploy role"
  value       = module.frontend_deploy_role.role_arn
}

