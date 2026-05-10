# cloud-devops-lab — AWS infrastructure skeleton
#
# Models: VPC, security group, ECS cluster
#
# WARNING: Do not run terraform apply without billing controls configured.
# This configuration is for validation and portfolio demonstration only.
# Running apply will create billable AWS resources.
#
# Safe commands:
#   terraform init -backend=false
#   terraform fmt -check -recursive
#   terraform validate
#   terraform plan   (requires AWS credentials and billing controls)

# VPC — isolated network for the lab environment
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Security group — controls ingress and egress for the app service
resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Security group for the ${var.project_name} application service"
  vpc_id      = aws_vpc.main.id

  # Allow inbound traffic to the application port from within the VPC only
  ingress {
    description = "App port from VPC"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ingress_cidr]
  }

  # Allow all outbound traffic
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

# ECS cluster — container orchestration target for the app service
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-cluster"
  }
}
