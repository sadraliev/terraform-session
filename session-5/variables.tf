

variable "env" {
  description = "the environment"
  type        = string
  default     = "dev"
}
variable "provider_name" {
  description = "the provider"
  type        = string
  default     = "aws"
}
variable "region" {
  description = "the region"
  type        = string
  default     = "usw2"
}
variable "business_unit" {
  description = "the business unit"
  type        = string
  default     = "orders"
}
variable "project_name" {
  description = "the project name"
  type        = string
  default     = "tom"
}
variable "tier" {
  description = "Application tier"
  type        = string
  default     = "db"
}
variable "Team" {
  description = "Team name"
  type        = string
  default     = "DevOps"
}
variable "owner" {
  description = "Owner name"
  type        = string
  default     = "john@mail.com"
}
variable "managed_by" {
  description = "Managed by"
  type        = string
  default     = "Terraform"
}
