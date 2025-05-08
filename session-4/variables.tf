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

variable "ingress_ports" {
  description = "The ports to allow ingress traffic on"
  type        = list(number)
  default     = [22, 80, 443, ]

}
variable "public_cidrs" {
  description = "The CIDR blocks to allow ingress traffic from"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", ]
}

variable "private_cidrs" {
  description = "The CIDR blocks to allow ingress traffic from"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", ]
}

variable "availability_zones" {
  description = "The availability zones to launch the instance in"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
  default     = "sadraliev@mac"
}

