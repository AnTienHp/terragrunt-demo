terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-acm.git?ref=v2.12.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  domain_name         = "*.antientf.tk"
  validation_method   = "DNS"
}

