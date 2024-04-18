terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      "source"                = "hashicorp/aws"
      "version"               = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
