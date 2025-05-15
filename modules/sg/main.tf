resource "aws_security_group" "main" {
  name        = var.sg_config.name
  description = var.sg_config.description

  vpc_id = var.sg_config.vpc_id != "" ? var.sg_config.vpc_id : null
  tags   = var.sg_config.tags

}

resource "aws_security_group_rule" "ingress" {
  for_each          = { for idx, rule in local.ingress_rules : idx => rule }
  type              = "ingress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "tcp"
  cidr_blocks       = [each.value.cidr] // TODO: Why I should use cidr_blocks instead of source_security_group_id?
  security_group_id = aws_security_group.main.id
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


