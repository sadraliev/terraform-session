variable "domain_name" {
  description = "The domain name to create the certificate for"
  type        = string
}

variable "validation_method" {
  description = "The validation method to use for the certificate"
  type        = string
  default     = "DNS"
}

variable "tags" {
  description = "The tags to apply to the certificate"
  type        = map(string)
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "The zone ID of the ALB"
  type        = string
}
