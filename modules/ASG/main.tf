resource "aws_launch_template" "app" {
  name_prefix   = var.asg_config.lt.name_prefix
  image_id      = var.asg_config.lt.image_id
  instance_type = var.asg_config.lt.instance_type

  user_data = filebase64("user-data.sh")

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.asg_config.lt.security_group_ids
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.asg_config.lt.tags
  }
}



resource "aws_autoscaling_group" "asg" {
  name                = var.asg_config.asg.name
  desired_capacity    = var.asg_config.asg.desired_capacity
  max_size            = var.asg_config.asg.max_size
  min_size            = var.asg_config.asg.min_size
  vpc_zone_identifier = var.asg_config.asg.vpc_zone_identifier

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = var.asg_config.asg.target_group_arns



  lifecycle {
    create_before_destroy = true
  }
}



