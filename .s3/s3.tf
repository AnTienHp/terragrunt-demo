resource "aws_s3_bucket" "terraform-s3-for-terragrunt" {
  bucket = "exam-state"
  versioning {
    enabled = true
}

lifecycle {
  prevent_destroy = true
}

tags = {
  Name = "exam-state"
  }
}