# Set common variables for the region. This is automatically pulled in in the
# root terragrunt.hcl configuration to configure the remote state bucket and
# pass forward to the child modules as inputs.
locals {
  aws_region = "us-east-2"
  azs        = ["us-east-2a", "us-east-2b", "us-east-2c"]
}
