terraform {
  backend "s3" {
    bucket                  = "gabriel-cloudhight-assessment-tf-bucket"
    key                     = "terraform-statefile-project"
    region                  = "eu-west-2"
    shared_credentials_file = "~/.aws/credentials"
  }
}


provider "aws" {
  region = var.region
}