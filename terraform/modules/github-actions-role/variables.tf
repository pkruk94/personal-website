variable "context" {
  description = "Variables needed for IAM role creation."
  type = object({
    role_name = string,
    role_description = string,
    policy_name = string,
    policy_descrition = string,
    policy_json = string,
    assume_role_policy_json = string,
    tags = optional(map(string), {})
  })
}