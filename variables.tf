variable "profile" {
  description = "Terraform AWS profile"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "name" {
  description = "Resource name"
  type        = string
}

variable "managed_by" {
  description = "Entity managing the resource"
  type        = string
  default     = "Terraform"
}

variable "public_key" {
  description = "Public SSH key"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "volume_type" {
  description = "EBS volume type"
  type        = string
}

variable "volume_size" {
  description = "EBS volume size (in GiB)"
  type        = number
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
}

variable "kms_key_id" {
  description = "KMS for EBS encryption for default aws."
  type        = string
}
