# To setup a s3 bucket and push static files to it and allow for static webhosting

# steps
# 1.setup provider
provider "aws" {
    region = "ap-south-1"
    access_key = var.access_key1
    secret_key = var.secret_key1
}

# 2.setup resource => s3 bucket
resource "aws_s3_bucket" "bucket" {
    bucket = "terraform-project-gds-1"
}

# 3.set objectownership controls -> object owner preferred
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# 4.Unblock public access for this bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 5.setup public read acess to bucket acl
resource "aws_s3_bucket_acl" "public_read_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.public_access,
  ]

  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
}

# 6.upload files to bucket

    # file1 -> index.html
    resource "aws_s3_object" "object1" {
    bucket = aws_s3_bucket.bucket.id
    key    = "index.html"
    source = "index.html"

    acl = "public-read"
    content_type = "text/html"

    etag = filemd5("index.html")
    }

    # file2 -> error.html
    resource "aws_s3_object" "object2" {
    bucket = aws_s3_bucket.bucket.id
    key    = "error.html"
    source = "error.html"

    acl = "public-read"
    content_type = "text/html"

    etag = filemd5("error.html")
    }

# 7.enable static webhosting and setup main and error pages
resource "aws_s3_bucket_website_configuration" "webhosting" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}