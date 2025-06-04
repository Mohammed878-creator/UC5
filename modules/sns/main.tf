resource "aws_sns_topic" "image_processing" {
  name = var.topic_name
}

resource "aws_sns_topic_subscription" "email_subscription" {
  count     = length(var.subscription_emails)
  topic_arn = aws_sns_topic.image_processing.arn
  protocol  = "email"
  endpoint  = var.subscription_emails[count.index]
}