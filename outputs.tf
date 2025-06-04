output "source_bucket_name" {
  value = module.s3.source_bucket_name
}

output "destination_bucket_name" {
  value = module.s3.destination_bucket_name
}

output "lambda_function_name" {
  value = module.lambda.lambda_name
}

output "sns_topic_arn" {
  value = module.sns.topic_arn
}