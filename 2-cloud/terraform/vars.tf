variable "data_bucket_prefix" {
  type    = string
  default = "nc-demo-de-quotes"
}
variable "lambda_name" {
  type    = string
  default = "quote_handler"
}

variable "python_runtime" {
  type    = string
  default = "python3.12"
}
