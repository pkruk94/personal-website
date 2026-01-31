terraform {
  # backend "s3" {
  #   bucket         = "personal-website-tf-state"
  #   key            = "personal-website-tf-state-bootstrap/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform--state-locking"
  #   encrypt        = true
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
}

