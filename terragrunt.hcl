# -----------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools fo
# working with multiple Terraform modules, remote state, and locking:
# https://github.com/gruntwork-io/terragrunt
# -----------------------------------------------------------------------------

locals {
  # Automatically load account-level variables
  # account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  # environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  # account_name = local.account_vars.locals.account_name
  # account_id   = local.account_vars.locals.aws_account_id
  aws_region = local.region_vars.locals.aws_region
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {

  access_key = "${get_env("AWS_ACCESS_KEY_ID")}"

  assume_role {
    role_arn     = "${get_env("DEPLOY_ROLE_ARN")}"
    session_name = "hackfest.provisioning"
  }
  
  region = "${local.aws_region}"
  secret_key = "${get_env("AWS_SECRET_ACCESS_KEY")}"
}
EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    bucket         = "${get_env("DEPLOY_TF_BUCKET", "my-terraform-bucket")}"
    dynamodb_table = "${get_env("DEPLOY_TF_DYNAMODB", "terraform-state-lock")}"
    encrypt        = true
    key            = "cyhy-hackfest-2022-09/${get_env("DEPLOY_ENVIRONMENT")}/${path_relative_to_include()}/terraform.tfstate"
    region         = "${get_env("AWS_REGION", "us-east-1")}"
    role_arn       = "${get_env("DEPLOY_TF_BACKEND_ROLE_ARN")}"
    session_name   = "access.terraform.backend"
  }
}
EOF
}

# -----------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are
# automatically merged into the child `terragrunt.hcl` config via the include
# block.
# -----------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is
# especially helpful with multi-account configs where terraform_remote_state
# data sources are placed directly into the modules.
inputs = merge(
  # local.account_vars.locals,
  local.region_vars.locals,
  # local.environment_vars.locals,
)
