# TF state S3 bucket deploy to AWS 
resource "aws_s3_bucket" "netstream-tfstate" {
  bucket        = "netstream-terraform-state-2026"
  force_destroy = false
  lifecycle {
    prevent_destroy = true
  }
}

/*
# Note : Skipping versioning for cost concern
# Enable Versioning for the TFState S3 bucket
resource "aws_s3_bucket_versioning" "netstream-tfstate-versioning" {
  bucket = aws_s3_bucket.netstream-tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}
*/

# Enable Server-Side Encryption for the TFState S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "netstream-tfstate-encryption" {
  bucket = aws_s3_bucket.netstream-tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "netstream-tfstate-public-access-block" {
  bucket                  = aws_s3_bucket.netstream-tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Add modules here
