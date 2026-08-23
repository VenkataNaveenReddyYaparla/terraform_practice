provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "sample_bucket" {
  bucket = "my-terraform-practice-bucket-1534323"
}
resource "aws_s3_bucket_acl" "sample_bucket" {
    bucket = aws_s3_bucket.sample_bucket.id
    acl    = "private"    
}

resource "aws_s3_bucket_versioning" "sample_bucket" {
  bucket = aws_s3_bucket.sample_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
