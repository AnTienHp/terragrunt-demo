terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-autoscaling.git?ref=v3.8.0"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../alb", "../sg", "../vpc", "../keypair"]
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "alb" {
  config_path = "../alb"
}

dependency "sg" {
  config_path = "../sg"
}

dependency "keypair" {
  config_path = "../keypair"
}

dependency "aws-data" {
  config_path = "../aws-data"
}

locals {
  user_data = <<EOF
  #!/bin/bash
  sudo yum update -y 
  sudo yum upgrade -y
  sudo yum install telnet mysql -y
  sudo yum -y install httpd
  echo "Hello World" > /var/www/html/index.html
  service httpd start
  chkconfig httpd on
  EOF
}

inputs = {
  # Creates a unique name beginning with the specified prefix
  name                = "example-with-elb"  # Creates a unique name for launch configuration beginning with the specified prefix
  lc_name             = "exam"

  image_id            = dependency.aws-data.outputs.amazon_linux2_aws_ami_id
  # The size of instance to launch
  instance_type       = "t2.micro"
  key_name            = dependency.keypair.outputs.this_key_pair_key_name
  user_data_base64    = base64encode(local.user_data)
  security_groups     = [dependency.sg.outputs.this_security_group_id]
  # Auto scaling group
  vpc_zone_identifier = dependency.vpc.outputs.public_subnets
  # Controls how health checking is done. Values are - EC2 and ELB
  health_check_type   = "EC2"
  # The minimum size of the auto scale group
  min_size            = 2
  # The maximum size of the auto scale group
  max_size            = 4
  # The number of Amazon EC2 instances that should be running in the group
  desired_capacity    = 2
  # Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling
  force_delete        = true
  target_group_arns   = dependency.alb.outputs.target_group_arns

}