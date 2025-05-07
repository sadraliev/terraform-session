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
  vpc_id      = aws_vpc.main_vpc.id

}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  count             = length(var.ingress_ports)
  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = element(var.ingress_cidrs, count.index)
  from_port         = element(var.ingress_ports, count.index)
  ip_protocol       = "tcp"
  to_port           = element(var.ingress_ports, count.index)
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
