module "ubuntu_docker" {
  source = "./modules/ubuntu-docker"

  builder_region            = var.aws_region
  builder_availability_zone = var.availability_zone
  # iam_instance_profile      = aws_iam_instance_profile.ec2_ecr.name
  docker_image = var.docker_image

  # should_build = false
}
