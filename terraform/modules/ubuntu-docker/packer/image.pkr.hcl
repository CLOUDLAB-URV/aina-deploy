packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.8"
    }
  }
}

variable "aws_region" {
  type    = string
  description = "AWS region to build the AMI in"
  default = "us-east-1"
}

variable "availability_zone" {
  type    = string
  description = "Availability zone to build the AMI in"
  default = "us-east-1b"
}

variable "instance_type" {
  type    = string
  description = "EC2 instance type"
  default = "t2.micro"
}

variable "ami_name" {
  type    = string
  description = "Name of the AMI to create"
  default = "ubuntu-24.04-docker"
}

variable "iam_instance_profile" {
  type    = string
  description = "IAM instance profile name for the Packer build instance"
  default = null
}

variable "disk_size" {
  type    = number
  description = "Size of the root EBS volume in GB"
  default = 15
}

variable "source_image_filter" {
  type    = string
  description = "Source image filter for finding the base AMI"
  default = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
}

variable "docker_image" {
  type    = string
  description = "Docker image name to pull"
}

source "amazon-ebs" "ubuntu24" {
  region        = var.aws_region
  availability_zone = var.availability_zone
  instance_type = var.instance_type
  ami_name      = var.ami_name
  

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = var.disk_size
    volume_type = "gp3"
    delete_on_termination = true
  }

  source_ami_filter {
    filters = {
      name                = var.source_image_filter
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Ubuntu / Canonical official owner
  }

  ssh_username = "ubuntu"

  iam_instance_profile = var.iam_instance_profile

  tags = {
    Name       = var.ami_name
  }
}

build {
  name    = var.ami_name
  sources = ["source.amazon-ebs.ubuntu24"]

  provisioner "shell" {
    script = "install_docker.sh"
    environment_vars = [
      "DOCKER_IMAGE=${var.docker_image}",
    ]
  }

  post-processor "manifest" { 
    output = ".manifest.json"
    strip_path = true
  }

  post-processor "shell-local" {
    inline = [
      "jq -j '.builds[-1].artifact_id | split(\":\") | .[1]' .manifest.json > ../.ami_id"
    ]
  }
}
