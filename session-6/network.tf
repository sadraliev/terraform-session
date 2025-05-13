resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(local.common_tags, { Name = "vpc" })
}

resource "aws_subnet" "public_subnet" {
  for_each = {
    for subnet in var.public_subnets :
    subnet.availability_zone => subnet
  }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = replace(local.name, "resource", "public-subnet") })
}

resource "aws_subnet" "private_subnet" {
  for_each = {
    for subnet in var.private_subnets :
    subnet.availability_zone => subnet
  }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false
  tags                    = merge(local.common_tags, { Name = replace(local.name, "resource", "private-subnet") })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = replace(local.name, "resource", "igw") })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = replace(local.name, "resource", "public-rt") })
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rt_association" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
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
