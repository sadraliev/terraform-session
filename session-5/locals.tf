# Naming Convention: Naming standard

# 1. Provider: aws, azurerm, 
# 2. Region: usw1, use1 - done
# 3. Resource Type: vpc, subnet, security_group
# 4. Environment: dev, qa, stage, prod
# 5. Business Unit: finance, hr, it, payments, streaming
# 6. Project Name: project1, project2
# 7. Tier: web, app, db

# Example: aws-usw1-vpc-finance-project1-web-dev

# Tagging Convention: Tagging standard
# 1. Environment: dev, qa, stage, prod
# 2. Project Name: project1, project2
# 3. Business Unit: finance, hr, it, payments, streaming
# 4. Team: DevOps, SRE, Platform, Security
# 5. Owner: example@mail.com
# 6. Managed By: Terraform, CloudFormation, Ansible, manual
# 7. Lead: example@akumosolutions.io 
# 8. Market: na, emea, apac

# AWS Configuration to delete resources without tag and name convention

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
