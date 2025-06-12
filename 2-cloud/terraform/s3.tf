resource "aws_s3_bucket" "data_bucket" {
  #TODO: Provision an S3 bucket for the data. 
  #TODO: Your bucket will need a unique, but identifiable name. Hint: Use the vars. 
  #TODO: Make sure to add an appropriate tag to this resource
  bucket_prefix = var.data_bucket_prefix
  tags = {
    Name = "Review Day Sprint Bucket"
    Environment = "Dev"
  }
}
# This creates an S3 bucket with a prefix defined in the variables file followed by a unique identifier.
# tags are added to the bucket for identification and management purposes.