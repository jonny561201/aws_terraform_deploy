//create lambda cloudwatch logs
resource "aws_cloudwatch_log_group" "NodeLambdaCloudWatchGroup" {
  name = "/aws/lambda/${aws_lambda_function.NodeLambda.function_name}"
  retention_in_days = 7
}