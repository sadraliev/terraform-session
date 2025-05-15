variable "alb_config" {
  type = object({
    alb = object({
      name               = string
      internal           = bool
      load_balancer_type = string
      subnets            = list(string)
      security_groups    = list(string)
    })
    target_group = object({
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
}
