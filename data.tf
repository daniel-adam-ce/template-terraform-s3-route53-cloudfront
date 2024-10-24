data "aws_iam_policy_document" "example_bucket_policy" {
    statement {
        principals {
          type="AWS"
          identifiers = ["*"]
        }
        
        actions = [
            "s3:getObject",
        ]

        resources = [
            aws_s3_bucket.example_bucket.arn,
            "${aws_s3_bucket.example_bucket.arn}/*"
        ]
    }

    depends_on = [ aws_s3_bucket.example_bucket, aws_s3_bucket_public_access_block.example_bucket_public_access_block ]
}

data "aws_route53_zone" "main" {
  name = var.domain_name
}