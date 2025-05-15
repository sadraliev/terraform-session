terraform {
  backend "s3" {
    bucket  = "terraform-session-backend-bucket-aibek"
    key     = "homework-7/dev/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}
