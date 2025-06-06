variable "instance_type" {
  description = "The type of AWS instance to launch"
  type        = string
  default     = "t2.micro"

}
variable "environment" {
  description = "The environment to launch the instance in"
  type        = string
  default     = "dev"

}
variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI

}

variable "vpc_security_group_ids" {
  description = "The security group IDs to associate with the instance"
  type        = list(string)
  default     = []
}
variable "tags" {
  description = "The tags to apply to the instance"
  type        = map(string)
  default     = {}
}
variable "availability_zone" {
  description = "The availability zone to launch the instance in"
  type        = string
}
variable "user_data" {
  description = "The user data to pass to the instance"
  type        = string
  default     = ""
}
