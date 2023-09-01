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
  source = "${local.base_source_url}//.?version=1.1.0"
}

# -----------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# -----------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env    = local.environment_vars.locals.environment
  region = local.region_vars.locals.aws_region

  # Expose the base source URL so different versions of the module can be
  # deployed in different environments. This will be used to construct the
  # terraform block in the child terragrunt configurations.
  # The URL used below (tfr:///) is a shorthand for
  # "tfr://registry.terraform.io/cloudposse...". For more info, see:
  # https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/
  base_source_url = "tfr:///cloudposse/ec2-instance/aws"
}

# -----------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines
# the parameters that are common across all environments.
# -----------------------------------------------------------------------------
inputs = {
  associate_public_ip_address = true
  environment                 = local.env
  instance_type               = "t3.micro"
  name                        = "lemmy"
  namespace                   = local.region
  subnet                      = dependency.vpc.outputs.public_subnets[0]
  vpc_id                      = dependency.vpc.outputs.vpc_id
}
