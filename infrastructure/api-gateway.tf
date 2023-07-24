locals {
  products_platform_app_name = "products-platform"
}

resource "aws_api_gateway_rest_api" "products_platform" {
    name = local.products_platform_app_name
    tags        = local.tags
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.products_platform.id
  parent_id   = aws_api_gateway_rest_api.products_platform.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.products_platform.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_any" {
  rest_api_id             = aws_api_gateway_rest_api.products_platform.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_any.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${local.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.products_platform_api.arn}/invocations"
  content_handling        = "CONVERT_TO_TEXT"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_method_response" "proxy_any" {
  rest_api_id         = aws_api_gateway_rest_api.products_platform.id
  resource_id         = aws_api_gateway_resource.proxy.id
  http_method         = aws_api_gateway_method.proxy_any.http_method
  status_code         = "200"
  response_models     = {
    "application/json" = "Empty" 
  }
}

resource "aws_api_gateway_integration_response" "proxy_any" {
  rest_api_id       = aws_api_gateway_rest_api.products_platform.id
  resource_id       = aws_api_gateway_resource.proxy.id
  http_method       = aws_api_gateway_method.proxy_any.http_method
  status_code       = aws_api_gateway_method_response.proxy_any.status_code
  content_handling  = "CONVERT_TO_TEXT"
  selection_pattern = "2\\d{2}"
}

resource "aws_lambda_permission" "products_platform_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.products_platform_api.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${local.region}:${local.aws_account_id}:${aws_api_gateway_rest_api.products_platform.id}/*/*/${aws_api_gateway_resource.proxy.path_part}"
}

resource "aws_api_gateway_deployment" "v1" {
  rest_api_id = aws_api_gateway_rest_api.products_platform.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.products_platform,
      aws_api_gateway_method.proxy_any,
      aws_api_gateway_integration.proxy_any,
      aws_api_gateway_method_response.proxy_any
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_integration.proxy_any,
    aws_api_gateway_method_response.proxy_any,
    aws_api_gateway_method.proxy_any
  ]
}

resource "aws_api_gateway_stage" "v1" {
  deployment_id = aws_api_gateway_deployment.v1.id
  rest_api_id   = aws_api_gateway_rest_api.products_platform.id
  stage_name    = "v1"
}