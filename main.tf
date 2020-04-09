variable "commit" {}
variable "s3_lambda_deploy_bucket" {
  type = string
  default = "jgraf-lambda-deploy"
}

provider "aws" {
  version = "~> 2.0"
  region = "us-east-2"
  shared_credentials_file = "/c/Users/g825714/.aws/"
}

//creates a custom policy document with multiple policies applied
data "aws_iam_policy_document" "example_policy_doc" {
  statement {
    sid = "1"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${var.s3_lambda_deploy_bucket}",
    ]
  }
}

//creates a policy with the document of existing policies applied
resource "aws_iam_policy" "example_policy" {
  name = "example_policy"
  path = "/"
  policy = data.aws_iam_policy_document.example_policy_doc.json
}

//creates a role with default lambda policies
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

//attaches my custom policy to my basic lambda role
resource "aws_iam_role_policy_attachment" "test-attach" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.example_policy.arn
}

resource "aws_lambda_function" "test_lambda" {
  function_name = "test-function"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "lambda_test.test_function"
  runtime = "python3.7"
  s3_bucket = aws_s3_bucket.lambda_deploy.bucket
  s3_key = "lambda_test_${var.commit}.zip"
  depends_on = [
    aws_s3_bucket.lambda_deploy]
}

resource "aws_s3_bucket" "lambda_deploy" {
  bucket = var.s3_lambda_deploy_bucket
  force_destroy = true
  acl = "private"

  tags = {
    Name = "Lambda Deploy"
    Environment = "Dev"
  }
}