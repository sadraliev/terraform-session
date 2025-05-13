resource "aws_lb" "alb" {
  name               = substr(replace(local.name, "resource", "alb-tg"), 0, 32)
  internal           = var.alb_config.alb.internal
  load_balancer_type = var.alb_config.alb.load_balancer_type
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.terraform_remote_state.network.outputs.network_info.private_subnet_ids
}

resource "aws_lb_target_group" "alb_tg" {
  # only alphanumeric and hyphen. Length must be less than 32
  name     = substr(replace(local.name, "resource", "alb-tg"), 0, 32)
  port     = var.alb_config.tg.port
  protocol = var.alb_config.tg.protocol
  vpc_id   = data.terraform_remote_state.network.outputs.network_info.vpc_id

  health_check {
    path                = var.alb_config.tg.health_check.path
    interval            = var.alb_config.tg.health_check.interval
    timeout             = var.alb_config.tg.health_check.timeout
    healthy_threshold   = var.alb_config.tg.health_check.healthy_threshold
    unhealthy_threshold = var.alb_config.tg.health_check.unhealthy_threshold
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb_config.listener.port
  protocol          = var.alb_config.listener.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_security_group" "alb_sg" {
  name   = replace(local.name, "resource", "alb-sg")
  vpc_id = data.terraform_remote_state.network.outputs.network_info.vpc_id

  dynamic "ingress" {
    for_each = var.alb_config.sg.ingress_ports
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "alb_config" {
  type = object({
    alb = object({
      internal           = bool
      load_balancer_type = string
    })
    sg = object({
      ingress_ports = list(object({
        port     = number
        protocol = string
      }))
    })
    tg = object({
      port     = number
      protocol = string
      health_check = object({
        path                = string
        interval            = number
        timeout             = number
        healthy_threshold   = number
        unhealthy_threshold = number
      })
    })
    listener = object({
      port     = number
      protocol = string
    })
  })
  default = {
    alb = {
      internal           = false
      load_balancer_type = "application"
    }
    sg = {
      ingress_ports = [
        {
          port     = 80
          protocol = "tcp"
        },
        {
          port     = 443
          protocol = "tcp"
        }
      ]
    }
    tg = {
      port     = 80
      protocol = "HTTP",
      health_check = {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
    }
    listener = {
      port     = 80
      protocol = "HTTP"
    }
  }
}
