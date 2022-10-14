terraform {
  cloud {
    organization = "data-puppeteer"

    workspaces {
      name = "gh-actions-demo"
    }
  }

  required_providers{
      aws = {
          source = "hashicorp/aws"
          version = "~> 3.27"
      }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
    profile = "default"
    region = "eu-west-1"  
}

resource "aws_s3_bucket" "demo-bucket" {
    bucket = "puppeteer-demo-bucket"

    tags = {
        Name = "S3Bucket"
    }
}

#Resource to enable versioning 
resource "aws_s3_bucket_versioning" "versioning_demo" {
  bucket = aws_s3_bucket.demo-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Resource to enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "demo-encryption" {
  bucket = aws_s3_bucket.demo-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Adds an ACL to bucket
resource "aws_s3_bucket_acl" "demo_bucket_acl" {
  bucket = aws_s3_bucket.demo-bucket.bucket
  acl    = "private"
}

#Block Public Access
resource "aws_s3_bucket_public_access_block" "demo_public_block" {
  bucket = aws_s3_bucket.demo-bucket.bucket

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}