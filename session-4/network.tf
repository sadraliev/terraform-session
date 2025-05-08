resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "${var.environment}-vpc",
    Environment = "${var.environment}"
  }
}

// connect the vpc to the internet
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = "${var.environment}"
  }
}

// open the public subnets to the internet
resource "aws_subnet" "public_subnet" {
  count = length(var.public_cidrs)

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = element(var.public_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true


  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment = "${var.environment}"
  }
}


// create a route table for the public subnets
//TODO: AWS route tables only control outbound (egress) routing logic ????
// @Kris, we need to talk about this!
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

// create a route (it is like a rule) in the Public Route Table

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0" // send it to the Internet Gateway.
  // TODO:is the outbound traffic or inbound traffic
  // TODO: where is the inbound traffic coming from?
  gateway_id = aws_internet_gateway.main_igw.id

}

// associate the public subnets to THE ROUTE TABLE
resource "aws_route_table_association" "public" {
  count          = length(var.public_cidrs)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public.id
}
// Security groups & network ACLs = control whether traffic is allowed (i.e., firewall rules)

# Security Groups (SGs):
# - Attached to EC2 instances, ENIs, or load balancers
# - Control inbound and outbound rules per port/protocol.
# - Stateful: if you allow outbound, return inbound is allowed automatically.

# Network ACLs (NACLs):
# - Attached to subnets.
# - Also control inbound and outbound, but are stateless.
# - You must allow traffic both directions explicitly.


# User's Browser
#    ↓
# Internet
#    ↓
# AWS Internet Gateway (IGW) //TODO: HOW ????
#    ↓
# Route Table (with 0.0.0.0/0 → IGW)
#    ↓
# Public Subnet (e.g., 10.0.1.0/24)
#    ↓
# EC2 Instance (with Public IP) 
#    ↓
# Security Group (allows TCP 80)
#    ↓
# Web Server (e.g., Node.js)

resource "aws_eip" "main_eip" {
  domain = "vpc"
  tags = {
    Name        = "${var.environment}-eip"
    Environment = "${var.environment}"
  }
}

resource "aws_nat_gateway" "main_nat" {
  allocation_id = aws_eip.main_eip.id
  subnet_id     = element(aws_subnet.public_subnet[*].id, 0)
  tags = {
    Name        = "${var.environment}-nat"
    Environment = "${var.environment}"
  }

  depends_on = [aws_internet_gateway.main_igw] // TODO: Why is depends_on needed?
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.private_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "private_internet_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main_nat.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_cidrs)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private.id
}
