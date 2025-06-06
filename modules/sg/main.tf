resource "aws_security_group" "main" {
  name        = var.sg_config.name
  description = var.sg_config.description
  vpc_id      = var.sg_config.vpc_id != "" ? var.sg_config.vpc_id : null
  tags        = var.sg_config.tags

}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each          = { for idx, rule in local.ingress_rules : idx => rule }
  from_port         = each.value.port
  to_port           = each.value.port
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = each.value.cidr
}
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.main.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}


locals {
  ingress_ports = coalesce(var.sg_config.ingress_ports, [])
  ingress_cidrs = coalesce(var.sg_config.ingress_cidrs, [])
  ingress_rules = flatten([
    for port in local.ingress_ports : [
      for cidr in local.ingress_cidrs : {
        port = port
        cidr = cidr
      }
    ]
  ])
}


