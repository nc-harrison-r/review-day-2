data "archive_file" "lambda" {
  type             = "zip"
  output_file_mode = "0666"
  source_file      = "${path.module}/../src/quotes.py"
  output_path      = "${path.module}/../function.zip"
}


/*
The quotes.py lambda will need access to the dependencies in the layer folder to run the code in AWS. 
These dependencies are bundled into a .zip file to be deployed as a layer.
*/

data "archive_file" "layer" {
  type             = "zip"
  output_file_mode = "0666"
  source_dir       = "${path.module}/../layer/"
  output_path      = "${path.module}/../layer.zip"
}


resource "aws_lambda_layer_version" "requests_layer" {
  layer_name          = "requests_layer"
  compatible_runtimes = [var.python_runtime]
  filename            = "${path.module}/../layer.zip" # this should point to the layer deployment package
# some students have put the filename as data.archive_file.layer.output_path
}

resource "aws_lambda_function" "quote_handler" {
  #TODO: Provision the lambda
  function_name = "get_quote"
  filename = "${path.module}/../function.zip"
  handler = "quotes.lambda_handler"
  runtime = var.python_runtime
  role = aws_iam_role.lambda_role.arn
  timeout = 10
  #TODO: Connect the layer which is outlined above
  layers = [aws_lambda_layer_version.requests_layer.arn]
    # So Terraform tracks whether it needs to redeploy the function:
  source_code_hash = data.archive_file.lambda.output_base64sha256

environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.data_bucket.bucket
    }
  }
}

