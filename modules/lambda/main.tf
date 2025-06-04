resource "aws_lambda_function" "image_resizer" {
  function_name    = var.function_name
  role             = var.lambda_role_arn
  handler          = "image_resizer.lambda_handler"
  runtime          = "python3.9"
  timeout          = var.timeout
  memory_size      = var.memory_size
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  filename = data.archive_file.lambda_zip.output_path

  environment {
    variables = {
      DESTINATION_BUCKET = var.destination_bucket
      SNS_TOPIC_ARN      = var.sns_topic_arn
      RESIZED_WIDTH      = var.resized_width
      RESIZED_HEIGHT     = var.resized_height
    }
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_resizer.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.source_bucket_arn
}