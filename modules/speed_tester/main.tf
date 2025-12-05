terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# 1. IAM Role (Allows Lambda to run)
resource "aws_iam_role" "lambda_exec" {
  name = "speed_test_role_${var.region_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Attach Basic Execution Policy (Logs)
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 2. The Lambda Function
resource "aws_lambda_function" "speed_test" {
  function_name = "global_speed_test"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  timeout       = 10 # 10 seconds is plenty for the 2.5s logic
  memory_size   = 128
  
  filename         = var.zip_path
  source_code_hash = var.zip_hash

  environment {
    variables = {
      TARGET_URL = "" # Optional default
    }
  }
}

# 3. The Function URL (Public Endpoint)
resource "aws_lambda_function_url" "url" {
  function_name      = aws_lambda_function.speed_test.function_name
  authorization_type = "NONE" # Publicly accessible
  
  cors {
    allow_origins = ["*"]
    allow_methods = ["GET"]
  }
}
