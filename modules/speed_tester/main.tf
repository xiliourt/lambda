terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

# 1. Lambda Function
resource "aws_lambda_function" "speed_test" {
  function_name = "global_speed_test_${var.region_name}"
  
  # Use the Global IAM Role ARN passed from root
  role          = var.role_arn  
  
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  timeout          = 10
  memory_size      = 128
  filename         = var.zip_path
  source_code_hash = var.zip_hash

  environment {
    variables = { TARGET_URL = "" }
  }
}

# 2. Function URL (Public Endpoint) with CORS Disabled
resource "aws_lambda_function_url" "url" {
  function_name      = aws_lambda_function.speed_test.function_name
  authorization_type = "NONE"

  # [UPDATED] CORS Protection Disabled
  cors {
    allow_origins = ["*"]  # Allow any website to call this
    allow_methods = ["*"]  # Allow GET, POST, PUT, DELETE, etc.
    allow_headers = ["*"]  # Allow any header
    max_age       = 86400  # Cache the preflight response for 1 day
  }
}

# --- Variables & Outputs ---

variable "role_arn" {
  type = string
}

variable "region_name" {
  type = string
}

variable "zip_path" {
  type = string
}

variable "zip_hash" {
  type = string
}

output "function_url" {
  value = aws_lambda_function_url.url.function_url
}
