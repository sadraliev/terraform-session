variable "instance_type" {
  description = "The type of AWSinstance to launch"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "The environment to launch the instance in"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The AWS region to launch the instance in"
  type        = string
  default     = "us-east-2"
}

variable "public_subnets" {
  default = {
    "us-east-2a" = "10.0.1.0/24"
    "us-east-2b" = "10.0.2.0/24"
    "us-east-2c" = "10.0.3.0/24"
  }
}
