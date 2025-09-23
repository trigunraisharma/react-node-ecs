# ECR Repository
resource "aws_ecr_repository" "repo" {
  name                 = "${var.name}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.name}-repo"
  }
  force_delete = true
}

# Store repo URL in SSM so GitHub Actions can use it
resource "aws_ssm_parameter" "ecr_repo_url" {
  name        = "/${var.name}/ecr_repo_url"
  description = "ECR repo URL for backend"
  type        = "String"
  value       = aws_ecr_repository.repo.repository_url
  overwrite   = true
}