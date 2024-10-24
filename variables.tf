variable "bucket_name" {
    description = "Value of the Name tag for the S3 Bucket"
    type = string
    default = "example_bucket_name"
}

variable "bucket_domain_name" {
    description = "Domain name for the S3 Bucket"
    type = string
}

variable "domain_name" {
    description = "Route 53 domain name"
    type = string
}

variable "acm_cert" {
    description = "Certificate ARN for CloudFront Distribution"
    type = string
}

variable "route53_zone_id" {
    description = "Zone ID for the Imported Route53 Hosted Zone"
    type = string
}

variable "aws_region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}