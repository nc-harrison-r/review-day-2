data "archive_file" "lambda" {
  type             = "zip"
  #this tells aws that we wanr to create a zip file
  output_file_mode = "0666"
  #this sets the permissions for the zip file
  source_file      = "${path.module}/../src/quotes.py"
  #this is the path to the quotes.py file located in the src folder
  output_path      = "${path.module}/../function.zip"
  # this points to where the the zip file will be created locally (terraform will upload it to AWS)
}
#Packages the quotes.py file into a zip file for Lambda to use.


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
# creates a zip so that your lambda can do all of the pip install stuff from this venv

resource "aws_lambda_layer_version" "requests_layer" {
  layer_name          = "requests_layer"
  compatible_runtimes = [var.python_runtime] 
  # This is the runtime that the layer is compatible with.
  filename            = "${path.module}/../layer.zip" # this should point to the layer deployment package
# some students have put the filename as data.archive_file.layer.output_path
}
#uploads the layer to AWS Lambda, which contains the dependencies needed for the lambda function to run.

resource "aws_lambda_function" "quote_handler" {
  #TODO: Provision the lambda
  function_name = var.lambda_name
  # this names the lambda function in AWS
  filename = "${path.module}/../function.zip"
  # this points to the zipped python file
  handler = "quotes.lambda_handler"
  # Even though we zip the file, we still need to specify the handler because AWS needs the zip for the code, and the handler to know which function inside the zip to run.”
  runtime = var.python_runtime
  # tells AWS to use the python runtime specified in the variables file
  role = aws_iam_role.lambda_role.arn
  # references the iam role created in the iam.tf file which gives the lambda function permission to run
  timeout = 10
  # this sets the timeout for the lambda function to 10 seconds(so it doesn't give up too quickly)
  #TODO: Connect the layer which is outlined above
  layers = [aws_lambda_layer_version.requests_layer.arn]
  # this connects the layer to the lambda function (allowing dependencies to be used)
  source_code_hash = data.archive_file.lambda.output_base64sha256
  # Hash of the function code zip — used by Terraform to detect changes and trigger redeployment.

environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.data_bucket.bucket
    }
  }
  # you'll notice that the function references the bucket name from environment variables in the python code. Here we are passing the bucket name to the lambda function as an environment variable.
}
# This deployes the lambda function to AWS.


