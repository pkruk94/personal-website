variable "bucket_name" {
  description = "Name of the S3 bucket for static content storage."
  type        = string
  default     = "personal-website-bucket"
}

variable "cf_cache_token" {
  description = "Cloudflare API token for cache invalidation"
  type        = string
  sensitive   = true
  default     = ""
}

variable "cf_dns_token" {
  description = "CloudFlare API token for DNS setup"
  type        = string
  sensitive   = true
  default     = ""
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true
  default     = ""
}

variable "environment" {
  description = "Environment to deploy to"
  type        = string
}