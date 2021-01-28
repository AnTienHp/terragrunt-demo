terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds.git?ref=v2.20.0"
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

inputs = {
  # The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier
  identifier                      = "demo"
  # The database engine to use
  engine                          = "mysql"
  # The engine version to use
  engine_version                  = "5.7.19"
  # The instance type of the RDS instance
  instance_class                  = "db.t2.micro"
  # rds_allocated_storage
  allocated_storage               = 5
  #  Specifies whether the DB instance is encrypted
  storage_encrypted               = false
  #  The DB name to create. If omitted, no database is created initially
  name                            = "demodb"
  #  Username for the master DB user
  username                        = "user"
  #  Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file
  password                        = "YourPwdShouldBeLongAndSecure!"
  #  The port on which the DB accepts connections  
  port                            = 3306
  vpc_security_group_ids          = [dependency.sg.outputs.this_security_group_id]
  # The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00
  maintenance_window              = "Mon:00:00-Mon:03:00"
  # The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window
  backup_window                   = "03:00-06:00"
  # Specifies if the RDS instance is multi-AZ
  multi_az                        = true
  backup_retention_period         = 0 # disable backups to create DB faster 
  tags = {
    Owner                         = "exam"
    Environment                   = "dev"
  }
  subnet_ids                      = dependency.vpc.outputs.private_subnets # DB subnet group
  family                          = "mysql5.7" # DB parameter group
  major_engine_version            = "5.7"  # DB option group
  final_snapshot_identifier       = "examdb" # Snapshot name upon DB deletion
  deletion_protection             = false  # Database Deletion Protection
  enabled_cloudwatch_logs_exports = ["audit", "general"]

}