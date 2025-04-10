resource "aws_s3_bucket" "david-bucket" {
  bucket = "david-statefile-buc"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}