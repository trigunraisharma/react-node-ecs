#Provides an ECS cluster
resource "aws_ecs_cluster" "my-react-node-app-cluster" {
  name = "${var.name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#ECS task definition
resource "aws_ecs_task_definition" "my-react-node-app-task" {
  family                   = "${var.name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs-execution-role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.name}-container"
      image     = "${aws_ecr_repository.repo.repository_url}:latest" # <-- ECR image
      essential = true
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.name}-logs",
          "awslogs-region"        = var.aws_region,
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "my-react-node-app-service" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.my-react-node-app-cluster.id
  task_definition = aws_ecs_task_definition.my-react-node-app-task.arn
  desired_count   = var.backend_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend-tg.arn
    container_name   = "${var.name}-container"
    container_port   = var.app_port
  }

  depends_on = [
    aws_subnet.private,
  aws_lb_listener.http]
}