terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v2.66.0"
}

# Set the variables for the mautic module in this environment
inputs = {

  name                          = "exam"
  cidr                          = "20.10.0.0/16"
  azs                           = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets               = ["20.10.1.0/24", "20.10.2.0/24", "20.10.3.0/24"]
  public_subnets                = ["20.10.11.0/24", "20.10.12.0/24", "20.10.13.0/24"]
  database_subnets              = ["20.10.21.0/24", "20.10.22.0/24", "20.10.23.0/24"]
  create_database_subnet_group  = false
  enable_nat_gateway            = true
  single_nat_gateway            = true
}

# Automatically include settings from the root terragrunt.hcl in this account
include {
  path = find_in_parent_folders()
}