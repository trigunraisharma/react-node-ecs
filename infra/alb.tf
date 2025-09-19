resource "aws_lb" "backend-alb" {
  name               = "${var.name}-backend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id # All public subnets

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

#IP Target Group
resource "aws_lb_target_group" "backend-tg" {
  name        = "${var.name}-backend-tg"
  port        = var.app_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.my-react-node-app.id

  health_check {
    path                = "/api/hello" # or "/" depending on your app
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

#Define ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.backend-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend-tg.arn
  }
}