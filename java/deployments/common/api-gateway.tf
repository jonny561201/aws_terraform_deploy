//api gateway
resource "aws_api_gateway_rest_api" "JavaLambdaApi" {
  name = "my-test-api-${var.deploy_env}-${var.demo_type}"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_resource" "JavaApiGatewayResource" {
  rest_api_id = aws_api_gateway_rest_api.JavaLambdaApi.id
  parent_id = aws_api_gateway_rest_api.JavaLambdaApi.root_resource_id
  path_part = "myTestApi${var.deploy_env}${var.demo_type}"
}

resource "aws_api_gateway_method" "JavaApiGatewayMethod" {
  rest_api_id = aws_api_gateway_rest_api.JavaLambdaApi.id
  resource_id = aws_api_gateway_resource.JavaApiGatewayResource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "JavaApiGatewayIntegration" {
  rest_api_id = aws_api_gateway_rest_api.JavaLambdaApi.id
  resource_id = aws_api_gateway_resource.JavaApiGatewayResource.id
  http_method = aws_api_gateway_method.JavaApiGatewayMethod.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = aws_lambda_function.JavaLambda.invoke_arn
}

resource "aws_lambda_permission" "JavaApiGatewayLambdaPermission" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.JavaLambda.function_name
  principal = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_method_response" "ApiGatewayMethodSuccessResponse" {
  depends_on = [aws_lambda_function.JavaLambda]
  rest_api_id = aws_api_gateway_rest_api.JavaLambdaApi.id
  resource_id = aws_api_gateway_resource.JavaApiGatewayResource.id
  http_method = aws_api_gateway_method.JavaApiGatewayMethod.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "JavaApiGatewayIntegrationResponse" {
  depends_on = [aws_lambda_function.JavaLambda]
  rest_api_id = aws_api_gateway_rest_api.JavaLambdaApi.id
  resource_id = aws_api_gateway_resource.JavaApiGatewayResource.id
  http_method = aws_api_gateway_method.JavaApiGatewayMethod.http_method
  status_code = aws_api_gateway_method_response.ApiGatewayMethodSuccessResponse.status_code
}

resource "aws_api_gateway_deployment" "JavaApiGatewayDeployment" {
  depends_on = [aws_api_gateway_integration.JavaApiGatewayIntegration]
  rest_api_id = aws_api_gateway_rest_api.JavaLambdaApi.id
  stage_name = var.deploy_env
}