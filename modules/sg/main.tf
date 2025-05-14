resource "aws_security_group" "main" {
  name        = var.name
  description = var.description
  tags = {
    Name        = "${var.environment}-webserver-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  count             = length(var.ingress_ports)
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = element(var.ingress_cidrs, count.index)
  from_port         = var.ingress_ports[count.index]
  to_port           = var.ingress_ports[count.index]
  ip_protocol       = "tcp"
}
