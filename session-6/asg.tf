resource "aws_launch_template" "app" {
  name_prefix   = var.asg_config.lt.name_prefix
  image_id      = var.asg_config.lt.image_id
  instance_type = var.asg_config.lt.instance_type

  user_data = filebase64("user-data.sh")

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = replace(local.name, "resource", "app-lt")
    })
  }
}

resource "aws_security_group" "app_sg" {
  name   = replace(local.name, "resource", "app-sg")
  vpc_id = data.terraform_remote_state.network.outputs.network_info.vpc_id


  dynamic "ingress" {
    for_each = var.asg_config.sg.ingress_ports
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = replace(local.name, "resource", "asg")
  desired_capacity    = var.asg_config.asg.desired_capacity
  max_size            = var.asg_config.asg.max_size
  min_size            = var.asg_config.asg.min_size
  vpc_zone_identifier = data.terraform_remote_state.network.outputs.network_info.private_subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.alb_tg.arn]

  tag {
    key                 = "Name"
    value               = replace(local.name, "resource", "asg")
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


variable "asg_config" {
  type = object({
    lt = object({
      name_prefix   = string
      image_id      = string
      instance_type = string
    })
    sg = object({
      ingress_ports = list(object({
        port     = number
        protocol = string
      }))
    })
    asg = object({
      desired_capacity = number
      max_size         = number
      min_size         = number
    })
  })
  default = {
    lt = {
      name_prefix   = "app-instance"
      image_id      = "ami-058a8a5ab36292159"
      instance_type = "t2.micro"
    }
    sg = {
      ingress_ports = [
        {
          port     = 80
          protocol = "tcp"
        }
      ]
    }
    asg = {
      desired_capacity = 2
      max_size         = 3
      min_size         = 1
    }
  }
}
