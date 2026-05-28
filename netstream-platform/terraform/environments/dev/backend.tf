terraform {
  backend "s3" {
    bucket       = "netstream-terraform-state-2026"
    key          = "dev/netstream/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true #no need of DynamoDB table for state locking when using S3 backend with use_lockfile enabled
  }
}

