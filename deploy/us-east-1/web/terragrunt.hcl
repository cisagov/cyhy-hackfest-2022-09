# -----------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that
# helps keep code DRY and maintainable:
# https://github.com/gruntwork-io/terragrunt
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# -----------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. The root configuration
# contains settings that are common across all components and environments,
# such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the common configuration for the component. The common configuration
# contains settings that are common for the component across all environments.
include "common" {
  path = "${dirname(find_in_parent_folders())}/_common/web.hcl"
}

# -----------------------------------------------------------------------------
# We don't need to override any of the common parameters for this environment,
# so we don't specify any other parameters.
# -----------------------------------------------------------------------------
