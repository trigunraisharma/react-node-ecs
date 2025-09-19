output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the frontend"
  value       = aws_s3_bucket.my-react-frontend-app-bucket02.bucket
}

output "frontend_url" {
  description = "CloudFront URL for frontend"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer for backend"
  value       = aws_lb.backend-alb.dns_name
}

output "backend_service_name" {
  description = "ECS Service name for the backend app"
  value       = aws_ecs_service.my-react-node-app-backend-service.name
}

output "backend_task_definition" {
  description = "Task definition ARN for backend app"
  value       = aws_ecs_task_definition.my-react-node-app-backend-task.arn
}

output "cloudwatch_log_group" {
  description = "Log group name where ECS container logs are stored"
  value       = aws_cloudwatch_log_group.ecs_backend.name
}