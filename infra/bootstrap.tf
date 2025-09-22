provider "aws" {
  alias  = "bootstrap"
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf_state" {
  provider = aws.bootstrap
  bucket   = "my-react-node-app-terraform-state-bootstrap"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  provider = aws.bootstrap
  bucket   = "my-react-node-app-terraform-state-bootstrap"

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}