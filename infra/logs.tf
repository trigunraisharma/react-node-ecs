resource "aws_cloudwatch_log_group" "ecs_backend" {
  name              = "/ecs/${var.name}-backend"
  retention_in_days = 1 # keep logs for 1 day (adjust as needed)

  tags = {
    Environment = "dev"
    Project     = var.name
  }
}