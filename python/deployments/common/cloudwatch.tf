//create lambda cloudwatch logs
resource "aws_cloudwatch_log_group" "PythonLambdaCloudWatchGroup" {
  name = "/aws/lambda/${aws_lambda_function.PythonLambda.function_name}-${var.demo_type}"
  retention_in_days = 7
}