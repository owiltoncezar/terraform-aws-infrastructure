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

variable "state_key" {
  description = "State key in S3"
  type        = string
}
