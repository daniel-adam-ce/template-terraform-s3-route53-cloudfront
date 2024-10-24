output "bucket_id" {
  description = "ID of the Bucket"
  value       = aws_s3_bucket.example_bucket.id
}