variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda"
  type        = string
}

variable "destination_bucket" {
  description = "Name of the destination S3 bucket"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for notifications"
  type        = string
}

variable "source_bucket_arn" {
  description = "ARN of the source S3 bucket"
  type        = string
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Memory allocation for Lambda in MB"
  type        = number
  default     = 512
}

variable "resized_width" {
  description = "Width for resized images"
  type        = number
  default     = 800
}

variable "resized_height" {
  description = "Height for resized images"
  type        = number
  default     = 600
}