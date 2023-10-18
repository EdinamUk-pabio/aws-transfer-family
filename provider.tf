terraform {
  required_version = ">= 1.5.4" 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.15.0"
    }
  }
}

#provider configuration
provider "aws" {
  # Configuration options
  region  = "us-east-1"
}

