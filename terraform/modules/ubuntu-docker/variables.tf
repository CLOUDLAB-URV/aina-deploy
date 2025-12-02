variable "builder_region" {
  type        = string
  description = "AWS region to build the AMI in"
  default     = "us-east-1"
}

variable "builder_availability_zone" {
  type        = string
  description = "Availability zone to build the AMI in"
  default     = "us-east-1b"
}

variable "source_image_filter" {
  type        = string
  description = "Source image filter for finding the base AMI"
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
}

variable "target_image_name" {
  type        = string
  description = "Name of the target AMI to create"
  default     = "ubuntu-24.04-docker"
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile name for the Packer build instance"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the Packer build instance"
  default     = "t2.micro"
}

variable "disk_size" {
  type        = number
  description = "Size of the root EBS volume in GB"
  default     = 15
}

variable "should_build" {
  type        = bool
  description = "Whether to build a new AMI or not"
  default     = true
}

variable "docker_image" {
  type        = string
  description = "Docker image name to pull"
}