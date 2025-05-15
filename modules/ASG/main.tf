# launch template
resource "aws_launch_template" "instance" {
  name_prefix   = var.asg_config.launch_template.name_prefix
  image_id      = var.asg_config.launch_template.image_id
  instance_type = var.asg_config.launch_template.instance_type

  network_interfaces {
    security_groups             = var.asg_config.launch_template.network_interfaces.security_groups
    associate_public_ip_address = var.asg_config.launch_template.network_interfaces.associate_public_ip_address
    subnet_id                   = var.asg_config.launch_template.network_interfaces.subnet_id
  }

  user_data = base64encode(var.asg_config.launch_template.user_data)
}


resource "aws_autoscaling_group" "asg" {
  name                = var.asg_config.asg.name
  desired_capacity    = var.asg_config.asg.desired_capacity
  max_size            = var.asg_config.asg.max_size
  min_size            = var.asg_config.asg.min_size
  vpc_zone_identifier = var.asg_config.asg.vpc_zone_identifier

  launch_template {
    id      = aws_launch_template.instance.id
    version = "$Latest"
  }

  target_group_arns = var.asg_config.asg.target_group_arns



  lifecycle {
    create_before_destroy = true
  }
}



