# Creating ALB
resource "aws_lb" "app-alb" {
  name               = "APP-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.magri-elb.id]
  subnets            = [aws_subnet.pubsub01.id, aws_subnet.pubsub02.id]

  #enable_deletion_protection = true

  tags = {
    Environment = "app"
    Terraform   = "true"
  }
  depends_on = [aws_launch_template.app_template]
}

# Creating ALB target group
resource "aws_lb_target_group" "app-group" {
  name     = "APP-TARGET-GROUP"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-mAgri.id

  tags = {
    Environment = "app"
    Terraform   = "true"
  }
}

# Creating ALB Backend target group
resource "aws_lb_target_group" "app-group-backend" {
  name     = "APP-BACKEND-TARGET-GROUP"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-app.id

  health_check {
    path                = "/app/axiatadigitallabspvtltd-app/internal/health-check"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    #  matcher             = "200-499"
  }

  tags = {
    Environment = "app"
    Terraform   = "true"
  }

}

resource "aws_lb_listener" "app-lb" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "443"
  #port     = "80"
  protocol        = "HTTPS"
  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = "arn:aws:acm:ap-southeast-1:220848514221:certificate/f3cc30de-d213-42ce-b001-ebe9679d73e2"
  #alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-group.arn
  }
}

resource "aws_lb_listener_rule" "host_based_forward_routing" {
  listener_arn = aws_lb_listener.app-lb.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-group-backend.arn
  }

  condition {
    path_pattern {
      values = ["/app/*"]
    }
  }
}