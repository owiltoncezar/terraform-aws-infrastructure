resource "aws_s3_bucket" "terraform_state" {
  bucket        = "${var.bucket_name}-${var.account_id}"
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name      = "${var.bucket_name}-${var.account_id}"
    ManagedBy = var.managed_by
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

