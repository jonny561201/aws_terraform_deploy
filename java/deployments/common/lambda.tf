//create lambda
resource "aws_lambda_function" "test_lambda" {
  function_name = "test-function-${var.deploy_env}"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "com.App::handleRequest"
  runtime = "java8"
  memory_size = 256
  s3_bucket = aws_s3_bucket.lambda_deploy.bucket
  s3_key = "JavaLambda-${var.app_version}-SNAPSHOT.jar"
  environment {
    variables = {
      AWS_QUEUE = aws_sqs_queue.terraform_queue.name
    }
  }

  depends_on = [aws_s3_bucket.lambda_deploy, aws_s3_bucket_object.upload_project, aws_iam_role.iam_for_lambda]
}