terraform {
  required_providers {
    #TODO: aws will be a required provider here
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#TODO: add a 'provider' block for aws here 
provider "aws" {
  region = "eu-west-2"
}


data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
