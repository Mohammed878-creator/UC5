variable "source_bucket_name" {
  description = "Name of the source S3 bucket"
  type        = string
}

variable "destination_bucket_name" {
  description = "Name of the destination S3 bucket"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function to trigger"
  type        = string
}

variable "source_expiration_days" {
  description = "Number of days after which original images expire"
  type        = number
  default     = 30
}