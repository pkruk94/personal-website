variable "cloudflare_token" {
  type = string
  sensitive = true
}

variable "domain_name" {
  type = string
  default = "pawelkruk.me"
}