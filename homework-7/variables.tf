
locals {
  // Naming convention
  name = "${var.provider_name}-${var.region}-rtype-${var.business_unit}-${var.project_name}-${var.tier}-${var.env}"
  // Tagging convention
  common_tags = {
    Environment   = var.env
    Project_Name  = var.project_name
    Business_Unit = var.business_unit
    Team          = var.Team
    Owner         = var.owner
    Managed_By    = var.managed_by
  }
}

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
  default     = "ohio"
}
variable "business_unit" {
  description = "the business unit"
  type        = string
  default     = "payments"
}
variable "project_name" {
  description = "the project name"
  type        = string
  default     = "stripe"
}
variable "tier" {
  description = "Application tier"
  type        = string
  default     = "app"
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
