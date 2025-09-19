# ECR Repository
resource "aws_ecr_repository" "backend" {
  name                 = "${var.name}-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.name}-backend-repo"
  }
  force_delete = true
}

# Store repo URL in SSM so GitHub Actions can use it
resource "aws_ssm_parameter" "backend_ecr_url" {
  name        = "/${var.name}-backend/ecr_repo_url"
  description = "ECR repo URL for backend"
  type        = "String"
  value       = aws_ecr_repository.backend.repository_url
  overwrite   = true
}