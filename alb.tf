# Creating ALB
resource "aws_lb" "magri-alb" {
  name               = "MAGRI-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.magri-elb.id]
  subnets            = [aws_subnet.pubsub01.id, aws_subnet.pubsub02.id]

  #enable_deletion_protection = true

  tags = {
    Environment = "magri"
  }
  depends_on = [aws_launch_template.magri_template]
}

# Creating ALB target group
resource "aws_lb_target_group" "magri-group" {
  name     = "MAGRI-TARGET-GROUP"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-mAgri.id
}

resource "aws_lb_listener" "magri-lb" {
  load_balancer_arn = aws_lb.magri-alb.arn
  #port              = "443"
  port     = "80"
  protocol = "HTTP"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  #alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.magri-group.arn
  }
}