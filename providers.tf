terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "cloudops-sandbox-cred-admin"
}

/*
# Test TF locally
# Configure the local provider
terraform{
    required_providers {
      local = {
        source = "hashicorp/local"
        version = "~> 2.5"
      }
    }
}
# Create local test file
resource "local_file" "test_file" {
  content  = "Hello, Buttercup!"
  filename = "This is my TF project for StreamForge"
}
*/