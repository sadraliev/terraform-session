
# load balancer
resource "aws_lb" "alb" {
  name               = trim(substr(var.alb_config.target_group.name, 0, 32), "-")
  internal           = var.alb_config.alb.internal
  load_balancer_type = var.alb_config.alb.load_balancer_type
  security_groups    = var.alb_config.alb.security_groups
  subnets            = var.alb_config.alb.subnets
}

# target group
resource "aws_lb_target_group" "alb_tg" {
  # only alphanumeric and hyphen. Length must be less than 32
  name        = trim(substr(var.alb_config.target_group.name, 0, 32), "-")
  port        = var.alb_config.target_group.port
  protocol    = var.alb_config.target_group.protocol
  vpc_id      = var.alb_config.target_group.vpc_id
  target_type = "instance"

  health_check {
    path                = var.alb_config.target_group.health_check.path
    interval            = var.alb_config.target_group.health_check.interval
    timeout             = var.alb_config.target_group.health_check.timeout
    healthy_threshold   = var.alb_config.target_group.health_check.healthy_threshold
    unhealthy_threshold = var.alb_config.target_group.health_check.unhealthy_threshold
  }
}

# listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb_config.listener.port
  protocol          = var.alb_config.listener.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

