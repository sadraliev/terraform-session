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



