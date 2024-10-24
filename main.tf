resource "aws_s3_bucket" "example_bucket" {
  tags = {
    Name = var.bucket_name
  }
  
  # This will destroy any contents inside the bucket
  force_destroy = true
}


resource "aws_s3_bucket_public_access_block" "example_bucket_public_access_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_all_access" {
  bucket = aws_s3_bucket.example_bucket.id
  policy = data.aws_iam_policy_document.example_bucket_policy.json
  depends_on = [ aws_s3_bucket.example_bucket, aws_s3_bucket_public_access_block.example_bucket_public_access_block, data.aws_iam_policy_document.example_bucket_policy ]
}

# resource "aws_s3_bucket_website_configuration" "example" {
#   bucket = aws_s3_bucket.example_bucket.id

#   index_document {
#     suffix = "index.html"
#   }

# }

resource "aws_s3_object" "file_upload" {
  bucket = aws_s3_bucket.example_bucket.id

  # This key must match the index document suffix in the aws_s3_bucket_website_configuration
  key         = "index.html"
  content_type = "text/html"
  source      = local.object_source
  # The source_hash will allow Terraform to detect if there has been any changes to the file
  source_hash = filemd5(local.object_source)
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.example_bucket.bucket_regional_domain_name
    
    origin_id = aws_s3_bucket.example_bucket.id
  }

  enabled = true
  is_ipv6_enabled = true
  comment = "example"
  default_root_object = "index.html"

  aliases = [var.bucket_domain_name]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.example_bucket.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_cert
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_route53_record" "record_a" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.bucket_domain_name
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "record_aaaa" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.bucket_domain_name
  type    = "AAAA"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}