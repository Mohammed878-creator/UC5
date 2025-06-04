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
  source             = "./modules/lambda_function"
  function_name      = var.lambda_function_name
  role_arn           = module.iam.lambda_role_arn
  handler            = "image_resizer.lambda_handler"
  runtime            = "python3.11" # or your preferred runtime
  filename           = "./Functions/lambda_function.zip"
  source_bucket_name = module.s3_buckets.original_images_bucket_name
  dest_bucket_name   = module.s3_buckets.processed_images_bucket_name
  sns_topic_arn      = module.sns.topic_arn
  resize_width       = var.resize_width
  memory_size        = 512
  timeout            = 60
  tags               = var.tags
}