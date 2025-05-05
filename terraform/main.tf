
resource "aws_s3_bucket" "tf-bucket" {
	bucket = "devops-phase1-terraform"
}

resource "aws_s3_bucket_versioning" "tf-bucket-versioning" {
	bucket = aws_s3_bucket.tf-bucket.id
	versioning_configuration{
		status = "Enabled"
	}
}
