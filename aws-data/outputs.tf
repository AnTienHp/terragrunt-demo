output "amazon_linux2_aws_ami_id" {
  description = "AMI ID of Amazon Linux 2"
  value       = data.aws_ami.amazon_linux.id
}

output "arn" {
  description = "arn"
  value       = data.aws_acm_certificate.demo_cert.arn
}

