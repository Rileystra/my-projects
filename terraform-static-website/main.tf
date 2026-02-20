# Create S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"

  }
    error_document {
    key = "error.html"
  }
}

# Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "website/index.html"
  content_type = "text/html"
}
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "error.html"
  source       = "website/error.html"
  content_type = "text/html"

}

# Allow public read access
resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
      Resource = "${aws_s3_bucket.website_bucket.arn}/*"
    }]
  })
}

# Disable block public access
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

