resource "aws_instance" "main" {
  ami           = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name        = "${var.environment}-public-webserver"
    Environment = var.environment
  }
}
