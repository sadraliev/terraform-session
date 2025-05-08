resource "aws_instance" "webserver" {
  count         = length(var.public_cidrs)
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  user_data = templatefile("${path.module}/user-data.sh", {
    environment = var.environment,
  })

  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
  tags = {
    Name        = "${var.environment}-webserver"
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
  for_each = {
    for i, rule in local.ingress_rules : "${rule.cidr}-${rule.port}" => rule
  }
  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = each.value.cidr
  from_port         = each.value.port
  to_port           = each.value.port
  ip_protocol       = "tcp"
  description       = "Allow port ${each.value.port} from ${each.value.cidr}"
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
