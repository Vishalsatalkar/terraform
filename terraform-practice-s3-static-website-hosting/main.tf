resource "aws_s3_bucket" "website" {
    bucket = "my-unique-static-website-vishal"
}
# Allow Public access to the website visitors
resource "aws_s3_bucket_public_access_block" "public" {
    bucket = aws_s3_bucket.website.id
    block_public_acls       = false
    ignore_public_acls      = false
    block_public_policy     = false
    restrict_public_buckets = false  
}
# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.website.id
    index_document {
        suffix = "index.html"
    }
    error_document {
        key = "index.html"
    }
}
# Allow visitors to read website files only
resource "aws_s3_bucket_policy" "policy" {
    bucket = aws_s3_bucket.website.id
    depends_on = [aws_s3_bucket_public_access_block.public]
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "PublicReadWebsiteFiles"
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.website.arn}/*"

            }
        ]
    })
}
# Upload index.html
resource "aws_s3_object" "index" {
    bucket = aws_s3_bucket.website.id
    key = "index.html"
    source = "${path.module}/index.html"
    content_type = "text/html"
    etag = filemd5("${path.module}/index.html")
}
# Upload CSS.Style
resource "aws_s3_object" "style" {
    bucket = aws_s3_bucket.website.id
    key = "style.css"
    source = "${path.module}/style.css"
    content_type = "text/css"
    etag = filemd5("${path.module}/style.css")
}
# Display website URL
output "website_url" {
    description = "S3 static website endpoint"
    value = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}
output "bucket_name" {
    description = "S3 bucket name"
    value = aws_s3_bucket.website.bucket
}