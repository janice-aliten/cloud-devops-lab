variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Project name used in resource names and tags"
  type        = string
  default     = "cloud-devops-lab"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "allowed_ingress_cidr" {
  description = "CIDR allowed to reach the app port (restrict in production)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "app_port" {
  description = "Port the application container listens on"
  type        = number
  default     = 8000
}
