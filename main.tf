provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "data_lake" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "city_phoenix" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "city/city-phoenix.csv"
  source = "data/city-phoenix.csv"
}

resource "aws_s3_object" "state_az" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "state/state-az.csv"
  source = "data/state-az.csv"
}

resource "aws_s3_object" "state_ca" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "state/state-ca.csv"
  source = "data/state-ca.csv"
}

resource "aws_s3_object" "state_la" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "state/state-la.csv"
  source = "data/state-la.csv"
}
