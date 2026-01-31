provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  # Used for ACM - must be in us-east-1 for CloudFront
  region = "us-east-1"
  alias = "us_east_1"
}