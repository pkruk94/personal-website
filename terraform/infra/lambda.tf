data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../backend"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_iam_role" "lambda_update_counter_role" {
  name = "lambda-update-counter-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "lambda_update_counter_iam_policy_document" {
  statement {
    effect = "Allow"
    actions = ["dynamodb:UpdateItem"]
    resources = [aws_dynamodb_table.visit_count.id]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:us-east-1:*:*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_update_counter_execution_policy" {
  name = "VisitCounterExecutionPolicy"
  policy = data.aws_iam_policy_document.lambda_update_counter_iam_policy_document.json
  role   = aws_iam_role.lambda_update_counter_role.id
}

resource "aws_lambda_function" "visit_counter_lambda" {
  filename = data.archive_file.lambda_zip.output_path
  function_name = "VisitCounterLambda"
  role          = aws_iam_role.lambda_update_counter_role.arn
  handler = "lambda.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha512
  runtime = "python3.11"

  environment {
    variables = {
      TABLE_NAME = "SiteStatistics",
      PARTITION_KEY_NAME = "GlobalCounter",
      COUNTER_ID = "VisitCount"
    }
  }
}