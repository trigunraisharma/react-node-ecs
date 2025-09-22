provider "aws" {
  alias = "bootstrap"
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf_state" {
  provider = aws.bootstrap
  bucket        = "my-react-node-app-terraform-state-bootstrap"
  force_destroy = true

  tags = {
    Name = "Terraform State Bucket"
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  provider = aws.bootstrap
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  provider = aws.bootstrap
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}