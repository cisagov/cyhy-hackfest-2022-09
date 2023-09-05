# Set common variables for the environment. This is automatically pulled in in
# the root terragrunt.hcl configuration to feed forward to the child modules.
locals {
  environment            = get_env("DEPLOY_ENVIRONMENT")
  route53_hosted_zone_id = get_env("DEPLOY_ROUTE53_ZONE_ID")
}
