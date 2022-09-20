terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "cisa-cool-terraform-state"
    dynamodb_table = "terraform-state-lock"
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::210193616405:role/AccessTerraformBackend"
    key            = "cyhy-hackfest-2022-09/terraform.tfstate"
    session_name   = "access.terraform.backend"
  }
}
