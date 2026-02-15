resource "aws_s3_bucket" "assets" {
  bucket = "bedrock-assets-${var.assets_bucket_suffix}"
  tags = {
    Project = "Bedrock"
  }
}

resource "aws_s3_bucket_acl" "assets_acl" {
  bucket = aws_s3_bucket.assets.id
  acl    = "private"
} 

# Lambda role
resource "aws_iam_role" "lambda_exec" {
  name = "bedrock-asset-processor-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
  tags = { Project = "Bedrock" }
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "lambda_logs" {
  name = "bedrock-asset-processor-logs"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Package Lambda (uses local file in ../lambda)
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda"
  output_path = "${path.module}/../lambda/package.zip"
}

resource "aws_lambda_function" "asset_processor" {
  function_name = "bedrock-asset-processor"
  filename      = "${path.module}/../lambda/package.zip"
  handler       = "index.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec.arn
  publish       = true
  tags = { Project = "Bedrock" }
  depends_on = [aws_iam_role_policy.lambda_logs]
}

resource "aws_lambda_permission" "s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.assets.arn
}

resource "aws_s3_bucket_notification" "assets_notify" {
  bucket = aws_s3_bucket.assets.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.asset_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3_invoke]
}