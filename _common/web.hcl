# -----------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for an S3-backed website. The
# common variables for each environment to deploy mysql are defined here. This
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
  # Temporarily use my fork until a PR can be made against the upstream repo
  source = "github.com/dav3r/terraform-aws-s3-static-website//."
}

# -----------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# -----------------------------------------------------------------------------
locals {
  # Expose the base source URL so different versions of the module can be
  # deployed in different environments. This will be used to construct the
  # terraform block in the child terragrunt configurations.
  # The URL used below (tfr:///) is a shorthand for
  # "tfr://registry.terraform.io/cn-terraform...". For more info, see:
  # https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/
  # base_source_url = "tfr:///cn-terraform/s3-static-website/aws"

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  region                 = local.region_vars.locals.aws_region
  route53_hosted_zone_id = local.environment_vars.locals.route53_hosted_zone_id
}

# -----------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines
# the parameters that are common across all environments.
# -----------------------------------------------------------------------------
inputs = {
  create_route53_hosted_zone = false
  name_prefix                = local.region
  route53_hosted_zone_id     = local.route53_hosted_zone_id
  website_domain_name        = "dev.cisa.felddy.com"
}
