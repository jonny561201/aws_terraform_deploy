//create lambda
resource "aws_lambda_function" "JavaLambda" {
  function_name = "test-function-${var.deploy_env}-${var.demo_type}"
  role = aws_iam_role.JavaIAMForLambda.arn
  handler = "com.App::handleRequest"
  runtime = "java8"
  memory_size = 256
  timeout = 30
  s3_bucket = aws_s3_bucket.JavaLambdaDeploy.bucket
  s3_key = "JavaLambda-${var.app_version}-SNAPSHOT.jar"
  environment {
    variables = {
      AWS_QUEUE = aws_sqs_queue.JavaSqsQueue.name
    }
  }

  depends_on = [aws_s3_bucket.JavaLambdaDeploy, aws_s3_bucket_object.JavaUploadProject, aws_iam_role.JavaIAMForLambda]
}