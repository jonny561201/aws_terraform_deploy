variable "commit" {}

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-2"
  shared_credentials_file = "/c/Users/g825714/.aws/"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  function_name = "test-function"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "lambda_test.test_function"
  runtime = "python3.7"
  s3_bucket = aws_s3_bucket.lambda_deploy.bucket
  s3_key = "lambda_test_${var.commit}.zip"
  depends_on = [aws_s3_bucket.lambda_deploy]
}

resource "aws_s3_bucket" "lambda_deploy" {
  bucket = "jgraf-lambda-deploy"
  acl    = "private"

  tags = {
    Name        = "Lambda Deploy"
    Environment = "Dev"
  }
}