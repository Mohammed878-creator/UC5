variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
}

variable "subscription_emails" {
  description = "List of email addresses to subscribe to notifications"
  type        = list(string)
  default     = ["mdshaik878@gmail.com"]
}