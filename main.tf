terraform {

  cloud {
    organization = "{your-organization-name}"
    workspaces {
      name = "{your-workspace-name}"
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
  region = "us-west-2"
}

resource "aws_s3_bucket" "data_lake_bucket" {
  bucket = "{your-bucket-name}"
}

resource "aws_s3_bucket_ownership_controls" "data_lake" {
  bucket = aws_s3_bucket.data_lake_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "data_lake" {
  depends_on = [aws_s3_bucket_ownership_controls.data_lake]

  bucket = aws_s3_bucket.data_lake_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "data_lake" {
  bucket = aws_s3_bucket.data_lake_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "s3:*",
        Resource = [
          "${aws_s3_bucket.data_lake_bucket.arn}",
          "${aws_s3_bucket.data_lake_bucket.arn}/*"
        ],
        Principal = {
          AWS = [
            var.arn_of_s3_bucket_owner
          ]
        }
      }
    ]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "data_lake_lifecycle" {
  bucket = aws_s3_bucket.data_lake_bucket.id

  rule {
    id     = "expire_old_objects"
    status = "Enabled"

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}
