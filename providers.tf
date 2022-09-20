# Our test hackfest provider

provider "aws" {
  alias = "hackfest"
  assume_role {
    role_arn     = var.hackfest_provision_role_arn
    session_name = "hackfest.admin"
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}
