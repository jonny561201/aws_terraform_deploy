//create lambda
resource "aws_lambda_function" "PythonLambda" {
  function_name = "test-function-${var.deploy_env}-${var.demo_type}"
  role = aws_iam_role.PythonIAMForLambda.arn
  handler = "app.handle_request"
  runtime = "python3.7"
  s3_bucket = aws_s3_bucket.PythonLambdaDeploy.bucket
  s3_key = "lambda_python.zip"
  source_code_hash = filemd5("../../lambda_python.zip")
  environment {
    variables = {
      AWS_QUEUE = aws_sqs_queue.PythonSqsQueue.name
    }
  }

  depends_on = [aws_s3_bucket.PythonLambdaDeploy, aws_s3_bucket_object.PythonUploadProject, aws_iam_role.PythonIAMForLambda]
}