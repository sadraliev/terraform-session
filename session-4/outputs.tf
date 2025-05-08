output "aws_instance_public_ip" {
  value       = aws_instance.public_webserver[*].public_ip
  description = "value of the public ip of the instance"
}

output "aws_instance_private_ip" {
  value       = aws_instance.private_webserver[*].private_ip
  description = "value of the private ip of the instance"
}
output "aws_vpc_id" {
  value       = aws_vpc.main.id
  description = "value of the vpc id"
}
output "aws_private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}
output "aws_public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}
