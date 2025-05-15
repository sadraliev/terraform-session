variable "asg_config" {
  type = object({
    launch_template = object({
      name_prefix   = string
      image_id      = string
      instance_type = string
      network_interfaces = object({
        security_groups             = list(string)
        associate_public_ip_address = bool
      })
      user_data = string
    })
    asg = object({
      name                = string
      vpc_zone_identifier = list(string)
      target_group_arns   = list(string)
      desired_capacity    = number
      max_size            = number
      min_size            = number
    })
  })
}
