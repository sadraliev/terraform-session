output "aws_instance_public_ip" {
  value       = aws_instance.webserver[*].public_ip
  description = "value of the public ip of the instance"
}
