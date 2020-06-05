//api gateway
resource "aws_api_gateway_rest_api" "PythonLambdaApi" {
  name = "my-test-api-${var.deploy_env}-${var.demo_type}"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_resource" "PythonApiGatewayResource" {
  rest_api_id = aws_api_gateway_rest_api.PythonLambdaApi.id
  parent_id = aws_api_gateway_rest_api.PythonLambdaApi.root_resource_id
  path_part = "myTestApi${var.deploy_env}${var.demo_type}"
}

resource "aws_api_gateway_method" "PythonApiGatewayMethod" {
  rest_api_id = aws_api_gateway_rest_api.PythonLambdaApi.id
  resource_id = aws_api_gateway_resource.PythonApiGatewayResource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "PythonApiGatewayIntegration" {
  rest_api_id = aws_api_gateway_rest_api.PythonLambdaApi.id
  resource_id = aws_api_gateway_resource.PythonApiGatewayResource.id
  http_method = aws_api_gateway_method.PythonApiGatewayMethod.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = aws_lambda_function.PythonLambda.invoke_arn
}

resource "aws_lambda_permission" "PythonApiGatewayLambdaPermission" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.PythonLambda.function_name
  principal = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_method_response" "ApiGatewayMethodSuccessResponse" {
  depends_on = [aws_lambda_function.PythonLambda]
  rest_api_id = aws_api_gateway_rest_api.PythonLambdaApi.id
  resource_id = aws_api_gateway_resource.PythonApiGatewayResource.id
  http_method = aws_api_gateway_method.PythonApiGatewayMethod.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "PythonApiGatewayIntegrationResponse" {
  depends_on = [aws_lambda_function.PythonLambda]
  rest_api_id = aws_api_gateway_rest_api.PythonLambdaApi.id
  resource_id = aws_api_gateway_resource.PythonApiGatewayResource.id
  http_method = aws_api_gateway_method.PythonApiGatewayMethod.http_method
  status_code = aws_api_gateway_method_response.ApiGatewayMethodSuccessResponse.status_code
}

resource "aws_api_gateway_deployment" "PythonApiGatewayDeployment" {
  depends_on = [aws_api_gateway_integration.PythonApiGatewayIntegration]
  rest_api_id = aws_api_gateway_rest_api.PythonLambdaApi.id
  stage_name = var.deploy_env
}