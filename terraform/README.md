# Terraform — AWS Infrastructure Skeleton

This folder contains a Terraform configuration modelling a minimal AWS
infrastructure for running a containerized service on ECS.

## Resources modelled

| Resource | Purpose |
|---|---|
| `aws_vpc` | Isolated network for the service |
| `aws_security_group` | Ingress/egress rules for the app port |
| `aws_ecs_cluster` | Container orchestration target |

## Safe validation commands

These commands require no AWS credentials and incur no cost:

```bash
# Download provider plugins (no backend, no AWS auth needed)
terraform init -backend=false

# Check formatting
terraform fmt -check -recursive

# Validate configuration syntax and types
terraform validate
```

## Optional — plan only (requires AWS credentials)

If you have AWS credentials configured and billing controls in place:

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=ap-southeast-2

terraform plan
```

## WARNING — do not apply without billing controls

`terraform apply` will create real AWS resources that may incur charges.

Resources in this configuration that can cost money if applied:
- ECS cluster (no direct charge, but underlying compute will)
- VPC (no charge for VPC itself, but NAT Gateway, public IPs, and data
  transfer will)

If you apply for testing, always run `terraform destroy` immediately
after and confirm all resources are removed.

## Variables

| Variable | Default | Description |
|---|---|---|
| `aws_region` | `ap-southeast-2` | AWS region |
| `project_name` | `cloud-devops-lab` | Used in resource names and tags |
| `environment` | `dev` | Deployment environment |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR block |
| `allowed_ingress_cidr` | `10.0.0.0/16` | Source CIDR for app port access |
| `app_port` | `8000` | Application container port |
