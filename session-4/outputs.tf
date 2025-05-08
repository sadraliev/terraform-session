output "aws_instance_public_ip" {
  value       = aws_instance.public_webserver[*].public_ip
  description = "value of the public ip of the instance"
}

output "aws_instance_private_ip" {
  value       = aws_instance.private_webserver[*].private_ip
  description = "value of the private ip of the instance"
}
