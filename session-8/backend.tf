terraform {
  backend "s3" {
    bucket  = "terraform-session-backend-bucket-aibek"
    key     = "session-8/dev/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}
