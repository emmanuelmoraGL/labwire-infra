resource "aws_lb" "main" {
  name = "${var.name}-alb-${var.environment}"
  internal = false
  load_balancer_type = "application"
  security_groups = aws_security_group.alb
  subnets = var.public_subnets.*.id

  enable_deletion_protection = false
}

resource "aws_alb_target_group" "main" {
  name = "${var.name}-tg-${var.environment}"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type = "forward"
  }
}
