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

/*
resource "aws_lambda_layer_version" "requests_layer" {
  layer_name          = "requests_layer"
  compatible_runtimes = [var.python_runtime]
  filename            = # this should point to the layer deployment package
}

resource "aws_lambda_function" "quote_handler" {
  #TODO: Provision the lambda
  #TODO: Connect the layer which is outlined above
}
*/

