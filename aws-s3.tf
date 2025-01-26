# 5.1.3 - Create S3 Bucket
resource "aws_s3_bucket" "test_bucket" {
  bucket = "terraform-test-bucket-${random_integer.intiger.result}"
  tags = {
    Name = "Terraform Test Bucket"
  }
}


resource "random_integer" "intiger" {
  min = 500
  max = 1000
}