locals {
  name = "${var.provider_name}-${var.region}-resource-${var.business_unit}-${var.project_name}-${var.tier}-${var.env}"
  common_tags = {
    Environment   = var.env
    Region        = var.region
    Project       = var.project_name
    Business_Unit = var.business_unit
    Tier          = var.tier
    Owner         = var.owner
    Managed_By    = var.managed_by
    Team          = var.team
    Project       = var.project_name
  }
}

variable "provider_name" {
  type    = string
  default = "aws"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "business_unit" {
  type    = string
  default = "akumosolutions"
}

variable "project_name" {
  type    = string
  default = "homework#5"
}

variable "tier" {
  type    = string
  default = "devops"
}

variable "env" {
  type    = string
  default = "backend"
}

variable "owner" {
  type    = string
  default = "aibek"
}

variable "managed_by" {
  type    = string
  default = "terraform"
}

variable "team" {
  type    = string
  default = "devops"
}






