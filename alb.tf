## External Load Balancer ##
resource "aws_lb" "application_alb" {
  name               = "28cld-lamp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.http.id]
  subnets            = aws_subnet.alb_subnets.*.id

  enable_deletion_protection = false
}

## ALB Listener ##
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg80.arn
  }
}

