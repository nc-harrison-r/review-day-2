resource "aws_s3_bucket" "data_bucket" {
  bucket_prefix = "${var.data_bucket_prefix}-"

  tags = {
    Name        = var.data_bucket_prefix
  }
}

resource "aws_s3_bucket" "code_bucket" {
  bucket_prefix = "${var.code_bucket_prefix}-"

  tags = {
    Name        = var.code_bucket_prefix
  }
}

resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.code_bucket.bucket
  key = "quotes/function.zip"
  source = "${path.module}/../function.zip"
}

resource "aws_s3_object" "layer_code" {
  bucket = aws_s3_bucket.code_bucket.bucket
  key = "quotes/layer.zip"
  source = "${path.module}/../layer.zip"
}