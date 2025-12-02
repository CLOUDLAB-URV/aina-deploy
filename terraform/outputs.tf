output "spot_instance_public_ip" {
  value = aws_instance.spot_instance.public_ip
}

output "amplify_app_url" {
  value = "https://${var.branch_name}.${aws_amplify_app.my_amplify_app.default_domain}"
}
