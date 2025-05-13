data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "terraform-session-backend-bucket-aibek"
    key    = "session-6/terraform.tfstate"
    region = "us-east-2"
  }
}
