output "source_bucket_arn" {
  value = aws_s3_bucket.source.arn
}

output "source_bucket_name" {
  value = aws_s3_bucket.source.id
}

output "destination_bucket_arn" {
  value = aws_s3_bucket.destination.arn
}

output "destination_bucket_name" {
  value = aws_s3_bucket.destination.id
}