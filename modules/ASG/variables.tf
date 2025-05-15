variable "asg_config" {
  type = object({
    lt = object({
      name_prefix        = string
      image_id           = string
      instance_type      = string
      security_group_ids = [string]
      tags               = map(string)
    })
    asg = object({
      name                = string
      vpc_zone_identifier = [string]
      target_group_arns   = [string]
      desired_capacity    = number
      max_size            = number
      min_size            = number
    })
  })
  default = {
    lt = {
      name_prefix   = "app-instance"
      image_id      = "ami-058a8a5ab36292159"
      instance_type = "t2.micro"
    }

    asg = {
      name             = "app-asg"
      desired_capacity = 2
      max_size         = 3
      min_size         = 1
    }
  }
}
