resource "aws_s3_bucket" "data_bucket" {
  #TODO: Provision an S3 bucket for the data. 
  #TODO: Your bucket will need a unique, but identifiable name. Hint: Use the vars. 
  #TODO: Make sure to add an appropriate tag to this resource
}

resource "aws_s3_bucket" "code_bucket" {
  #TODO: Provision an S3 bucket for the lambda code. 
  #TODO: Your bucket will need a unique, but identifiable name. Hint: Use the vars. 
  #TODO: Make sure to add an appropriate tag to this resource
}

/* 
The quotes.py lambda will need access to its dependencies in the layer folder to run the code in AWS - in the lambda.tf these dependencies are bundled into a .zip file 
*/

resource "aws_s3_object" "layer_code" {
  bucket = aws_s3_bucket.code_bucket.bucket
  key = "quotes/layer.zip"
  source = "${path.module}/../layer.zip"
}

/*
resource "aws_s3_object" "lambda_code" {
  #TODO: Upload the lambda code to the code_bucket.
  #TODO: See lambda.tf for the path to the code.
}
*/



