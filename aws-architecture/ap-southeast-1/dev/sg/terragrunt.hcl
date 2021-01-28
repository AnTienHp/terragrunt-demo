terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-security-group.git?ref=v3.17.0"
}

dependencies {
  paths = ["../vpc"]
}

dependency "vpc" {
  config_path = "../vpc"
}

# Set the variables for the mautic module in this environment
inputs = {
  name        = "exam-db"
  description = "Security group for example usage with rds instance"
  vpc_id      = dependency.vpc.outputs.vpc_id

  # ingress_cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["mysql-tcp", "http-80-tcp", "https-443-tcp" ]
  egress_rules        = ["all-all"]
}


# Automatically include settings from the root terragrunt.hcl in this account
include {
  path = find_in_parent_folders()
}