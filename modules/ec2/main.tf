resource "aws_instance" "main" {
  ami           = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = var.vpc_security_group_ids
  availability_zone      = var.availability_zone
  user_data              = var.user_data

  tags = {
    Name        = "${var.environment}-public-webserver"
    Environment = var.environment
  }
}
