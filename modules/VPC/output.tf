output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_arn" {
  value = aws_vpc.main.arn
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnet : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnet : subnet.id]
}
