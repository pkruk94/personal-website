resource "aws_dynamodb_table" "visit_count" {
  name         = "SiteStatistics-${upper(var.environment)}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "StatisticId"
  attribute {
    name = "StatisticId"
    type = "S"
  }

  tags = local.common_tags
}