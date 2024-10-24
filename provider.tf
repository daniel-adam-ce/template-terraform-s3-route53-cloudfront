terraform {
  cloud {
    # your organization here
    organization = "test-repono"
    workspaces {
      # your workspace here
      name = "route53-cloudfront-s3"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}