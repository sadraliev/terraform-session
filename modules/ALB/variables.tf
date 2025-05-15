variable "alb_config" {
  type = object({
    alb = object({
      name               = string
      internal           = bool
      load_balancer_type = string
      subnets            = list(string)
      security_groups    = list(string)
    })
    taget_group = object({
      name     = string
      port     = number
      protocol = string
      vpc_id   = string
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
      name               = "dev-alb"
      internal           = false
      load_balancer_type = "application"
      subnets            = []
      security_groups    = []
    }
    target_group = {
      name     = "dev-alb-tg"
      port     = 80
      protocol = "HTTP",
      vpc_id   = ""
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
