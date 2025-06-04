resource "aws_s3_bucket" "source" {
  bucket = var.source_bucket_name

}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.source.id

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"
    filter_suffix       = ".jpg"
  }

#   depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_s3_bucket" "destination" {
  bucket = var.destination_bucket_name
}