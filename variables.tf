# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "appsync_service_role_arn" {
  description = "The ARN of the IAM role that has permissions to access the data sources."
  type        = string
}

variable "dynamodb_table_names" {
  description = "The names of the DynamoDB tables supporting the API."
  type        = map(string)
}

variable "hackfest_provision_role_arn" {
  description = "The ARN of the IAM role that has permissions to provision the resources for the hackfest."
  type        = string
}

variable "user_pool_id" {
  description = "The ID of the Cognito User Pool"
  type        = string
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region to deploy into (e.g. us-east-1)."
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to all AWS resources created."
  type        = map(string)
}
