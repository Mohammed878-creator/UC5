module "sns" {
  source              = "./modules/sns"
  topic_name          = "image-processing-notifications"
  subscription_emails = var.notification_emails
}

module "s3" {
  source                 = "./modules/s3"
  source_bucket_name     = "${var.project_name}-source-${random_id.bucket_suffix.hex}"
  destination_bucket_name = "${var.project_name}-destination-${random_id.bucket_suffix.hex}"
  lambda_function_arn    = module.lambda.lambda_arn

}

module "iam" {
  source               = "./modules/iam"
  role_name           = "${var.project_name}-lambda-role"
  policy_name         = "${var.project_name}-lambda-policy"
  source_bucket_arn   = module.s3.source_bucket_arn
  destination_bucket_arn = module.s3.destination_bucket_arn
  sns_topic_arn       = module.sns.topic_arn
}

module "lambda" {
  source              = "./modules/lambda"
  function_name       = "${var.project_name}-image-resizer"
  lambda_role_arn     = module.iam.role_arn
  destination_bucket  = module.s3.destination_bucket_name
  sns_topic_arn       = module.sns.topic_arn
  source_bucket_arn   = module.s3.source_bucket_arn
  timeout             = var.lambda_timeout
  memory_size         = var.lambda_memory_size
  resized_width       = var.resized_width
  resized_height      = var.resized_height
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}