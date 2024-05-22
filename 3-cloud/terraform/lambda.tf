/*
data "archive_file" "lambda" {
  type             = "zip"
  output_file_mode = "0666"
  source_file      = "${path.module}/../src/quotes.py"
  output_path      = "${path.module}/../function.zip"
}

data "archive_file" "layer" {
  #TODO: Use this archive_file block to create a deployment package for the layer.
}

resource "aws_lambda_layer_version" "requests_layer" {
  layer_name          = "requests_layer"
  compatible_runtimes = [var.python_runtime]
  s3_bucket           = # this should be the code_bucket you provision in s3.tf
  s3_key              = # this should be the key for your layer_code in s3.tf
}

resource "aws_lambda_function" "quote_handler" {
  #TODO: Provision the lambda
  #TODO: Connect the layer which is outlined above
}
*/