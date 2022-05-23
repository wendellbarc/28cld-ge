### Creating random string ###
resource "random_string" "s3-random" {
  length  = 8
  special = false
  upper   = false
}

### Creating private bucket ### 
resource "aws_s3_bucket" "static" {
  bucket = "28cld-lamp-${random_string.s3-random.id}"

  tags = {
    Name = "28cld-lamp-${random_string.s3-random.id}"
  }
}

resource "aws_s3_bucket_acl" "static_acl" {
  bucket = aws_s3_bucket.static.id
  acl    = "private"
}

