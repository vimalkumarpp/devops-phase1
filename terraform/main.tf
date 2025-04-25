resource "aws_instance" "first-instance" {
	ami = "ami-0001c5332b86ed44b"
	instance_type = "t3.micro"
	tags = {
		Name = "first-instance"
	}
}

resource "aws_s3_bucket" "tf-bucket" {
	bucket = "devops-phase1-terraform"
}

resource "aws_s3_bucket_versioning" "tf-bucket-versioning" {
	bucket = aws_s3_bucket.tf-bucket.id
	versioning_configuration{
		status = "Enabled"
	}
}
