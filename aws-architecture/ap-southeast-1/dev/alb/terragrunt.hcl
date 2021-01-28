terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-alb.git?ref=v5.10.0"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../vpc", "../sg"]
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sg" {
  config_path = "../sg"
}

dependency "aws-data" {
  config_path = "../aws-data"
}

inputs = {
  # The resource name and Name tag of the load balancer.
  name                  = "demo"
  vpc_id                = dependency.vpc.outputs.vpc_id
  security_groups       = [dependency.sg.outputs.this_security_group_id]
  subnets               = dependency.vpc.outputs.public_subnets
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = dependency.aws-data.outputs.arn
      target_group_index = 0
    }
  ]

  # A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port
  target_groups         = [
    {
      name_prefix          = "exam"
      backend_port         = 80
      backend_protocol     = "HTTP"
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 6
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 4
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        Name = "Target group for exam"
      }
    }
  ]
  # https_listener_rules  = var.alb_https_listener_rules

  # A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to http_tcp_listeners[count.index])
  http_tcp_listeners    = [
    {
      port               = 80
      protocol           = "HTTP"
      action_type = "redirect"  # Forward action is default, either when defined or undefined
      target_group_index = 0
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
  tags = {
    Project = "demo"
  }
}