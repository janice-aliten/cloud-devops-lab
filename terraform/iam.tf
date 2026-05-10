# cloud-devops-lab — AWS IAM skeleton
#
# Models least-privilege IAM resources for the FastAPI app running on ECS.
#
# Resources modelled:
#   aws_iam_role.ecs_task_execution  — allows ECS to pull images and write logs
#   aws_iam_role.ecs_task            — application task role with minimal permissions
#   aws_iam_policy.ecs_task          — custom policy scoped to this lab only
#   aws_iam_role_policy_attachment   — binds managed and custom policies to roles
#
# WARNING: terraform apply is never run in this repository.
# These resources are for validation and portfolio demonstration only.
# See terraform/README.md for safe validation commands.

# ── ECS Task Execution Role ───────────────────────────────────────────────────
# Assumed by the ECS agent to pull container images and publish logs.
# This is separate from the application role — principle of separation of duties.

resource "aws_iam_role" "ecs_task_execution" {
  name        = "${var.project_name}-ecs-execution-role"
  description = "Allows ECS to pull images from ECR and write logs to CloudWatch"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECSTasksAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ecs-execution-role"
  }
}

# Attach the AWS-managed ECS task execution policy.
# This grants the minimum permissions needed for ECS to run tasks.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_managed" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ── ECS Task Role ─────────────────────────────────────────────────────────────
# Assumed by the application container itself at runtime.
# Grants only what the application needs — not what ECS needs to run it.

resource "aws_iam_role" "ecs_task" {
  name        = "${var.project_name}-ecs-task-role"
  description = "Runtime role for the ${var.project_name} application container"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECSTasksAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:ecs:${var.aws_region}:*:*"
          }
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ecs-task-role"
  }
}

# ── Custom Task Policy ────────────────────────────────────────────────────────
# Least-privilege policy for the application task role.
# Scoped to CloudWatch Logs only — the application writes structured logs.
# Extend this policy when adding S3, Secrets Manager, or other integrations.

resource "aws_iam_policy" "ecs_task" {
  name        = "${var.project_name}-ecs-task-policy"
  description = "Least-privilege policy for the ${var.project_name} application task"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchLogsWrite"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:*:log-group:/ecs/${var.project_name}:*"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ecs-task-policy"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_custom" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.ecs_task.arn
}
