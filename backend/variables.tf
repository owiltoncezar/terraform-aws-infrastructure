variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "profile" {
  description = "AWS profile"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "managed_by" {
  description = "Tool that provisioned the resource"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for state locking"
  type        = string
}
