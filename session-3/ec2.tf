resource "aws_instance" "webserver" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  user_data = templatefile("${path.module}/user-data.sh", {
    environment = var.environment,
  })

  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  subnet_id = aws_subnet.public_subnet["${var.region}a"].id
  tags = {
    Name        = "${var.environment}-webserver"
    Environment = var.environment
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg"
  description = "Allow SSH access"

  vpc_id = aws_vpc.main_vpc.id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
