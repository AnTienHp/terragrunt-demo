resource "aws_dynamodb_table" "tflocktablefprterragrunt" {
  name = "exam_lock_id"
  hash_key = "LockID"
  read_capacity = 5
  write_capacity = 5
  attribute {
    name = "LockID"
    type = "S"
  }
}