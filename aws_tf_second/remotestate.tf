
terraform {
  backend "s3" {
    bucket = "baddtfremote"
    key    = "baddtfremote/project-abc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "main" {
  backend = "s3"
  config = {
    bucket = "baddtfremote"
    key    = "baddtfremote/project-abc/terraform.tfstate"
    region = "us-east-1"
  }
}
