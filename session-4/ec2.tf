resource "aws_instance" "public_webserver" {
  count         = length(var.public_cidrs)
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  user_data = templatefile("${path.module}/user-data.sh", {
    environment = var.environment,
  })

  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
  key_name  = var.key_name
  tags = {
    Name        = "${var.environment}-public-webserver"
    Environment = var.environment
  }
}
resource "aws_instance" "private_webserver" {
  count         = length(var.private_cidrs)
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
  key_name  = var.key_name
  tags = {
    Name        = "${var.environment}-private-webserver"
    Environment = var.environment
  }
}
resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg"
  description = "Allow ports ${join(", ", var.ingress_ports)}"
  vpc_id      = aws_vpc.main_vpc.id
  tags = {
    Name        = "${var.environment}-webserver-sg"
    Environment = var.environment
  }
}

// TODO: Aibek, don't forget to improve this code, you don't need to create a new security group ingress rule for each port, you can create a single rule for all ports
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  count             = length(var.ingress_ports)
  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.ingress_ports[count.index]
  to_port           = var.ingress_ports[count.index]
  ip_protocol       = "tcp"
  description       = "Allow port ${element(var.ingress_ports, count.index)} from 0.0.0.0/0"
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
