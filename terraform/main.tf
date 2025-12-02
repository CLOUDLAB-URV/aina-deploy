resource "aws_instance" "spot_instance" {
  ami                    = module.ubuntu_docker.ami_id
  instance_type          = var.instance_type
  subnet_id              = local.subnet_id
  vpc_security_group_ids = local.all_sg_ids

  dynamic "instance_market_options" {
    for_each = var.use_spot ? [1] : []
    content {
      market_type = "spot"

      spot_options {
        # max_price                      = "-1"
        spot_instance_type             = "one-time"
        instance_interruption_behavior = "terminate"
      }
    }
  }

  key_name = var.ssh_key_name

  # instance_profile = aws_iam_instance_profile.ec2_ecr.name

  user_data = <<-EOF
              #!/bin/bash
              systemctl enable docker
              systemctl start docker
              usermod -aG docker ubuntu || true
              docker pull ${var.docker_image}
              cat <<EOT > /home/ubuntu/app.env
              CORS_ORIGINS=https://${var.branch_name}.${aws_amplify_app.my_amplify_app.default_domain}
              KH_FEATURE_USER_MANAGEMENT_ADMIN=admin
              KH_FEATURE_USER_MANAGEMENT_PASSWORD=${var.admin_password}
              KH_FEATURE_USER_MANAGEMENT_AGENT_CREATOR=agent_creator
              KH_FEATURE_USER_MANAGEMENT_AGENT_CREATOR_PASSWORD=${var.agent_creator_password}
              KH_FEATURE_USER_MANAGEMENT_CHATUSER=cloudlab
              KH_FEATURE_USER_MANAGEMENT_CHATUSER_PASSWORD=${var.chatuser_password}
              USE_LIGHTRAG=false
              USE_MS_GRAPHRAG=false
              USE_LOW_LLM_REQUESTS=true
              EOT
              docker run -d \
                -p ${var.listen_port}:8000 \
                --restart unless-stopped  \
                --env-file /home/ubuntu/app.env \
                ${var.docker_image}
              EOF

  tags = {
    Name = "${var.environment}-spot-instance"
  }
}
