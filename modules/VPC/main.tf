resource "aws_vpc" "main" {
  cidr_block = var.vpc_config.vpc.cidr_block

  tags = var.vpc_config.vpc.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = var.vpc_config.igw.tags
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags   = var.vpc_config.public_rt.tags
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "public_subnet" {
  for_each = {
    for subnet in var.vpc_config.public_subnets :
    subnet.availability_zone => subnet
  }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags                    = each.value.tags
}

resource "aws_route_table_association" "public_rt_association" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

## private subnets
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags       = var.vpc_config.nat_eip.tags
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet["us-east-2a"].id
  tags          = var.vpc_config.nat.tags
}

resource "aws_subnet" "private_subnet" {
  for_each = {
    for subnet in var.vpc_config.private_subnets :
    subnet.availability_zone => subnet
  }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false
  tags                    = each.value.tags
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags   = var.vpc_config.private_rt.tags
}


resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_rt_association" {
  for_each       = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
