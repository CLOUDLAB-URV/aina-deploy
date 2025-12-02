resource "aws_amplify_app" "my_amplify_app" {
  name       = var.amplify_app_name
  repository = var.repository_url
  # oauth_token         = var.oauth_token
  access_token = var.access_token
  environment_variables = {
    VITE_IP_BACKEND = aws_apigatewayv2_api.my_api.api_endpoint
  }

  build_spec = <<-EOF
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm install -g pnpm
            - pnpm install
        build:
          commands:
            - pnpm run build
      artifacts:
        baseDirectory: dist
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
    EOF

  tags = {
    Name = var.amplify_app_name
  }
}

resource "aws_amplify_branch" "my_amplify_branch" {
  app_id      = aws_amplify_app.my_amplify_app.id
  branch_name = var.branch_name

  stage = "PRODUCTION"

  tags = {
    Name = "${var.amplify_app_name}-${var.branch_name}-branch"
  }
}
