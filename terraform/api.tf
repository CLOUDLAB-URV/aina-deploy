resource "aws_apigatewayv2_api" "my_api" {
  name          = "${var.environment}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.my_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "my_integration" {
  api_id = aws_apigatewayv2_api.my_api.id

  integration_type   = "HTTP_PROXY"
  integration_uri    = "http://${aws_instance.spot_instance.public_ip}:${var.listen_port}/{proxy}"
  integration_method = "ANY"
}

resource "aws_apigatewayv2_route" "my_route" {
  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.my_integration.id}"
}
