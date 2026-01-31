variable "domain_name" {
  type = string
  default = "pawelkruk.me"
}

variable "environment" {
  description = "Environment to deploy to"
  type = string

  validation {
    condition = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be 'dev' or 'prod'"
  }
}