variable "environment" {
  type        = string
  description = "Environment prefix for resource naming"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_newbits" {
  type        = number
  description = "Additional bits to add to VPC CIDR to derive subnet (e.g., 8 -> /24 from /16)"
  default     = 8
}

variable "subnet_index" {
  type        = number
  description = "Index of the subnet to derive using cidrsubnet"
  default     = 0
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "availability_zone" {
  type        = string
  description = "The availability zone for the instance"
  default     = "us-east-1b"
}

variable "ssh_key_name" {
  type        = string
  description = "The name of the SSH key pair to use for the instance"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "The type of instance to launch"
  default     = "c8i.xlarge"
}

variable "use_spot" {
  type        = bool
  description = "Whether to use spot instances"
  default     = false
}

variable "docker_image" {
  type        = string
  description = "Docker image name to run on the instance"
}

variable "listen_port" {
  type        = number
  description = "The port the container listens on"
  default     = 8000
}

variable "ami_name_pattern" {
  type        = string
  description = "AMI name pattern to filter the latest AMI"
  default     = "ubuntu-24.04-docker-awscli-*"
}

variable "additional_sg_ids" {
  type        = list(string)
  default     = []
  description = "List of additional security group IDs to attach to the instance"
}

variable "admin_password" {
  type        = string
  description = "Password for the admin user"
  sensitive   = true
}

variable "agent_creator_password" {
  type        = string
  description = "Password for the agent creator user"
  sensitive   = true
}

variable "chatuser_password" {
  type        = string
  description = "Password for the chatuser user"
  sensitive   = true
}

variable "amplify_app_name" {
  description = "The name of the AWS Amplify app."
  type        = string
}

variable "repository_url" {
  description = "The URL of the repository to be connected to the Amplify app."
  type        = string
}

variable "branch_name" {
  description = "The branch of the repository to be deployed."
  type        = string
}

variable "access_token" {
  description = "The access token for accessing the repository."
  type        = string
}
