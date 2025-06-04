variable "project_name" {
  description = "Name of the project (used for resource naming)"
  type        = string
  default     = "image-processor"
}

variable "notification_emails" {
  description = "List of email addresses to receive notifications"
  type        = list(string)
  default     = ["mdshaik878@gmail.com"]
}

variable "lambda_timeout" {
  description = "Timeout for Lambda function in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memory size for Lambda function in MB"
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