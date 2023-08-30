# -----------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for an EC2 instance. The common
# variables for each environment to deploy mysql are defined here. This
# configuration will be merged into the environment configuration via an include
# block.
# -----------------------------------------------------------------------------

# Terragrunt will copy the Terraform configurations specified by the source
# parameter, along with any files in the working directory, into a temporary
# folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with
# a different ref to override the deployed version.
terraform {
  # Note: //. is added after the URL to avoid the following Terragrunt warning:
  # "WARN[0000] No double-slash (//) found in source URL"
  # For more info, see: https://github.com/gruntwork-io/terragrunt/issues/1675
  source = "${local.base_source_url}//.?ref=v5.1.1"
}

# -----------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# -----------------------------------------------------------------------------
locals {
  # Expose the base source URL so different versions of the module can be
  # deployed in different environments. This will be used to construct the
  # terraform block in the child terragrunt configurations.
  base_source_url = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git"

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  azs = local.region_vars.locals.azs

  vpc_cidr = "10.0.0.0/16"
}

# -----------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines
# the parameters that are common across all environments.
# -----------------------------------------------------------------------------
inputs = {
  azs             = local.azs
  cidr            = local.vpc_cidr
  name            = "hackfest"
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
}
