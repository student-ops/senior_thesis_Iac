terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22.0"
    }
  }
}


provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = local.region
}


provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
locals {
  name   = replace(basename(path.cwd), "_", "-")
  region = "ap-northeast-1"
  app    = "my-potal"
}
