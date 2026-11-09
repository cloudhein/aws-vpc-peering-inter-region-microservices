resource "aws_lb" "service" {
  name                       = "microservices-statement"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [local.security.alb_security_group_id]
  subnets                    = local.network.private_subnet_ids
  drop_invalid_header_fields = true
  enable_http2               = true
}

resource "aws_lb_target_group" "app" {
  name        = "microservices-statement-app"
  port        = 9090
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = local.network.vpc_id
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app.id
  port             = 9090
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.service.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.service.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
