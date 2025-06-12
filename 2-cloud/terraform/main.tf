terraform {
  required_providers {
    #TODO: aws will be a required provider here
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# says that this project will use the aws tools from terraform, version 5.0 or higher


#TODO: add a 'provider' block for aws here 
provider "aws" {
  region = "eu-west-2"
}
# This sets the aws region to eu-west-2, which is London.


data "aws_caller_identity" "current" {}
#this retrieves the current AWS account ID


data "aws_region" "current" {}
# this retrieves current AWS region