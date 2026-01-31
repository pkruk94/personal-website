terraform {
  # backend "s3" {
  #   bucket         = "personal-website-tf-state"
  #   key            = "personal-website-infra/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-locking"
  #   encrypt        = true
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.15.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.0"
    }
  }
}