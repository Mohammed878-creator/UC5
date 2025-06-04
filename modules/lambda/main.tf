resource "aws_lambda_function" "image_resizer" {
  function_name    = var.function_name
  role             = var.lambda_role_arn
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  source_code_hash = filebase64sha256(var.filename)

  filename = var.filename

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

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = var.source_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_resizer.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3,aws_lambda_function.image_resizer]
} 