terraform {
  # backend "s3" {
  #   bucket         = "personal-website-tf-state-${var.environment}"
  #   key            = "personal-website-tf-state-bootstrap-${var.environment}/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform--state-locking-${var.environment}"
  #   encrypt        = true
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
}

