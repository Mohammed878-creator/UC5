variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
}

variable "source_bucket_arn" {
  description = "ARN of the source S3 bucket"
  type        = string
}

variable "destination_bucket_arn" {
  description = "ARN of the destination S3 bucket"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}