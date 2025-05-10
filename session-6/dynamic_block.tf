
resource "aws_security_group" "name" {
  name = "security-group"

  dynamic "ingress" {
    for_each = var.inbound_ports
    iterator = ports
    content {
      from_port   = ports.value.port
      to_port     = ports.value.port
      protocol    = ports.value.protocol
      cidr_blocks = ports.value.cidr_blocks
    }
  }
}
variable "inbound_ports" {
  type = list(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/24"]
      }, {
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.5.0/24"]
      }, {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.10.0/24"]
    }
  ]
}
