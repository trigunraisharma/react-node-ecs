resource "aws_ssm_parameter" "s3_bucket" {
  name  = "/myapp/s3_bucket"
  type  = "String"
  value = aws_s3_bucket.my-react-frontend-app-bucket02.bucket
}

resource "aws_ssm_parameter" "cloudfront_id" {
  name  = "/myapp/cloudfront_id"
  type  = "String"
  value = aws_cloudfront_distribution.s3_distribution.id
}

resource "aws_ssm_parameter" "ecr_repo_url" {
  name  = "/myapp/ecr_repo_url"
  type  = "String"
  value = aws_ecr_repository.backend.repository_url
}

resource "aws_ssm_parameter" "ecs_cluster" {
  name  = "/myapp/ecs_cluster"
  type  = "String"
  value = aws_ecs_cluster.my_cluster.name
}

resource "aws_ssm_parameter" "ecs_service" {
  name  = "/myapp/ecs_service"
  type  = "String"
  value = aws_ecs_service.my_service.name
}