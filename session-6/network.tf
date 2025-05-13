resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(local.common_tags, { Name = "vpc" })
}

resource "aws_subnet" "public_subnet" {
  for_each = {
    for subnet in var.public_subnets :
    subnet.cidr_block => subnet
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, { Name = replace(local.name, "resource", "public-subnet") })
}

resource "aws_subnet" "private_subnet" {
  for_each = {
    for subnet in var.private_subnets :
    subnet.cidr_block => subnet
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, { Name = replace(local.name, "resource", "private-subnet") })
}

output "network_info" {
  value = {
    vpc_id             = aws_vpc.main.id
    public_subnet_ids  = [for subnet in aws_subnet.public_subnet : subnet.id]
    private_subnet_ids = [for subnet in aws_subnet.private_subnet : subnet.id]
  }
}

variable "public_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-2a"
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-2b"
    },
    {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-2c"
    }
  ]
}


variable "private_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-2a"
    },
    {
      cidr_block        = "10.0.5.0/24"
      availability_zone = "us-east-2b"
    },
    {
      cidr_block        = "10.0.6.0/24"
      availability_zone = "us-east-2c"
    }
  ]
}
