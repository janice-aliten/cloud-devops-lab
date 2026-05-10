output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "app_security_group_id" {
  description = "ID of the application security group"
  value       = aws_security_group.app.id
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "aws_region" {
  description = "AWS region resources are modelled in"
  value       = var.aws_region
}

output "project_name" {
  description = "Project name used across resources"
  value       = var.project_name
}
