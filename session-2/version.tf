terraform {
  required_version = "~> 1.11.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.97.0"
    }
  }
}
# Lazy constraint
# ~>  Lazy constraint = version is not fixed and it will use the latest version of the provider

# Semver constraint
# Major - (Upgrade) significant changes, breaking changes
# Minor - (Update) New features
# Patch - (Patch) Bug fixes, vulnerabilities etc
