resource "aws_cloudfront_origin_access_control" "react_oac" {
  name                              = "react_oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}