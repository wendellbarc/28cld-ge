resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled         = true
  is_ipv6_enabled = false
  comment         = "cloudfront-28cld-webapp"
  price_class     = "PriceClass_100"
  origin {
    domain_name = aws_s3_bucket.static.bucket_regional_domain_name
    origin_id   = "cloudfront-28cld-webapp-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["HEAD", "GET"]
    viewer_protocol_policy = "allow-all"

    target_origin_id = "cloudfront-28cld-webapp-origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }


}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront-28cld-webapp-origin"
}