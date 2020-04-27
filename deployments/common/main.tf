variable "app_version" {}

variable "region" {}

variable "deploy_env" {}

variable "s3_lambda_deploy_bucket" {}

//creates a custom policy document with multiple policies applied
data "aws_iam_policy_document" "s3_policy_doc" {
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
resource "aws_iam_policy" "s3_policy" {
  name = "example_policy"
  path = "/"
  policy = data.aws_iam_policy_document.s3_policy_doc.json
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
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_lambda_function" "test_lambda" {
  function_name = "test-function"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "lambda_test.test_function"
  runtime = "python3.7"
  s3_bucket = aws_s3_bucket.lambda_deploy.bucket
  s3_key = "lambda_test_${var.app_version}.zip"
  depends_on = [aws_s3_bucket.lambda_deploy]
}

resource "aws_s3_bucket" "lambda_deploy" {
  bucket = var.s3_lambda_deploy_bucket
  force_destroy = true
  acl = "private"

  tags = {
    Name = "Lambda Deploy"
    Environment = var.deploy_env
  }
}


resource "aws_api_gateway_rest_api" "lambda_api" {
  name = "my-test-api"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_resource" "MyDemoResource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part = "mydemoresource"
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "MyDemoIntegration" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = aws_lambda_function.test_lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_method_response" "response_200" {
  depends_on = [aws_lambda_function.test_lambda]
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  depends_on = [aws_lambda_function.test_lambda]
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
}

resource "aws_api_gateway_deployment" "MyDemoDeployment" {
  depends_on = [aws_api_gateway_integration.MyDemoIntegration]
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  stage_name  = var.deploy_env
}