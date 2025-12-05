# modules/speed_tester/main.tf

terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

# 1. DELETE the 'aws_iam_role' resource block entirely
# 2. DELETE the 'aws_iam_role_policy_attachment' block entirely

# 3. Update the Lambda Function to use the variable
resource "aws_lambda_function" "speed_test" {
  function_name = "global_speed_test_${var.region_name}"
  
  # CHANGE THIS LINE:
  role = var.role_arn  
  
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

resource "aws_lambda_function_url" "url" {
  function_name      = aws_lambda_function.speed_test.function_name
  authorization_type = "NONE"
  cors {
    allow_origins = ["*"]
    allow_methods = ["GET"]
  }
}

# --- Variables ---

variable "role_arn" {
  type        = string
  description = "The ARN of the global IAM role to use"
}

variable "region_name" { type = string }
variable "zip_path" { type = string }
variable "zip_hash" { type = string }

output "function_url" {
  value = aws_lambda_function_url.url.function_url
}
