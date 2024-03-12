terraform {
  backend "s3" {
    bucket                  = "terraform-statefile-okiri"
    key                     = "terraform-statefile-project"
    region                  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}


provider "aws" {
  region = var.region
}