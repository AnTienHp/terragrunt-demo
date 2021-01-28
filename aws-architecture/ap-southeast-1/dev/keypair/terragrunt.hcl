terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-key-pair.git?ref=v0.6.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  
  key_name   = "mykeypair"
  public_key = file("~/.ssh/mykey.pub")
}