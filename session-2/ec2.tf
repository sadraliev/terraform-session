resource "aws_instance" "first_ec2" {
  ami           = "ami-058a8a5ab36292159"
  instance_type = "t2.micro"
  tags = {
    Name        = "aws-ec2-instance"
    Environment = "dev"
  }
}

resource "aws_security_group" "simple_sg" {
  name        = "simple-sg"
  description = "Allow SSH access"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#Interpolation
# Interpolation is a way to reference other resources or variables in your configuration
# Interpolation syntax is ${} and it can be used to reference other resources, variables, or outputs
# Example of interpolation
# output "instance_id" {
#   value = aws_instance.first_ec2.id
# }
# Output
# Output is a way to display information about your resources after they are created
# Example of output
# output "instance_public_ip" {
#   value = aws_instance.first_ec2.public_ip
# }


# Block & Argument

# 2 main blocks (resource vs source data)

# Resource block = create and manage resources
# Resource block has 2 lables = first label is the resource type and second label is the resource name
# The resource type is defined by the provider and the resource name is defined by the user
# The second label - logic name of the resource and it must be unique within the working directory

# Argument = configures the resource
# Argument is a key-value pair that defines the properties of the resource
# Argument  is known before the resource is created
# Attribute = a property of the resource. Known after the resource is created


# Data block = fetach data from endpoint

