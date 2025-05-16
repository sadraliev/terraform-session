terraform {
  backend "s3" {
    bucket               = "terraform-session-backend-bucket-aibek"
    key                  = "terraform.tfstate"
    region               = "us-east-2"
    encrypt              = true
    workspace_key_prefix = "workspaces"
  }
}
# terraform workspace show // This will show the current workspace
# terraform workspace list // This will list all workspaces
# how to reference the workspace name in the resource name
# terraform.workspace = currect workspace name
#! Each workspace will have its own tfstate file 
#! on S3 bucket workspaces/<workspace_name>/terraform.tfstate
