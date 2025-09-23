resource "aws_ssm_parameter" "s3_bucket" {
  name  = "/${var.name}/s3_bucket"
  type  = "String"
  value = aws_s3_bucket.my-react-node-app-bucket02.bucket
}

resource "aws_ssm_parameter" "cloudfront_id" {
  name  = "/${var.name}/cloudfront_id"
  type  = "String"
  value = aws_cloudfront_distribution.s3_distribution.id
}

resource "aws_ssm_parameter" "ecs_cluster" {
  name  = "/${var.name}/ecs_cluster"
  type  = "String"
  value = aws_ecs_cluster.my-react-node-app-cluster.name
}

resource "aws_ssm_parameter" "ecs_service" {
  name  = "/${var.name}/ecs_service"
  type  = "String"
  value = aws_ecs_service.my-react-node-app-service.name
}