resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.name}-logs"
  retention_in_days = 1 # keep logs for 1 day (adjust as needed)

  tags = {
    Environment = "dev"
    Project     = var.name
  }
}