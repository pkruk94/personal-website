variable "bucket_name" {
  description = "Name of the S3 bucket for static content storage."
  type        = string
  default     = "my-portfolio-bucket-4815162342108"
}

variable "cf_cache_token" {
  description = "Cloudflare API token for cache invalidation"
  type        = string
  sensitive   = true
}

variable "cf_dns_token" {
  description = "CloudFlare API token for DNS setup"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true
}