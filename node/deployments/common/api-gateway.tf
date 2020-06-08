//api gateway
resource "aws_api_gateway_rest_api" "NodeLambdaApi" {
  name = "my-test-api-${var.deploy_env}-${var.demo_type}"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_resource" "NodeApiGatewayResource" {
  rest_api_id = aws_api_gateway_rest_api.NodeLambdaApi.id
  parent_id = aws_api_gateway_rest_api.NodeLambdaApi.root_resource_id
  path_part = "myTestApi${var.deploy_env}${var.demo_type}"
}

resource "aws_api_gateway_method" "NodeApiGatewayMethod" {
  rest_api_id = aws_api_gateway_rest_api.NodeLambdaApi.id
  resource_id = aws_api_gateway_resource.NodeApiGatewayResource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "NodeApiGatewayIntegration" {
  rest_api_id = aws_api_gateway_rest_api.NodeLambdaApi.id
  resource_id = aws_api_gateway_resource.NodeApiGatewayResource.id
  http_method = aws_api_gateway_method.NodeApiGatewayMethod.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = aws_lambda_function.NodeLambda.invoke_arn
}

resource "aws_lambda_permission" "NodeApiGatewayLambdaPermission" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.NodeLambda.function_name
  principal = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_method_response" "ApiGatewayMethodSuccessResponse" {
  depends_on = [aws_lambda_function.NodeLambda]
  rest_api_id = aws_api_gateway_rest_api.NodeLambdaApi.id
  resource_id = aws_api_gateway_resource.NodeApiGatewayResource.id
  http_method = aws_api_gateway_method.NodeApiGatewayMethod.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "NodeApiGatewayIntegrationResponse" {
  depends_on = [aws_lambda_function.NodeLambda]
  rest_api_id = aws_api_gateway_rest_api.NodeLambdaApi.id
  resource_id = aws_api_gateway_resource.NodeApiGatewayResource.id
  http_method = aws_api_gateway_method.NodeApiGatewayMethod.http_method
  status_code = aws_api_gateway_method_response.ApiGatewayMethodSuccessResponse.status_code
}

resource "aws_api_gateway_deployment" "NodeApiGatewayDeployment" {
  depends_on = [aws_api_gateway_integration.NodeApiGatewayIntegration]
  rest_api_id = aws_api_gateway_rest_api.NodeLambdaApi.id
  stage_name = var.deploy_env
}