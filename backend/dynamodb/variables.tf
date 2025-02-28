variable "dynamodb_table_name" {
  description = "DynamoDB table name for state locking"
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

variable "managed_by" {
  description = "Tool that provisioned the resource"
  type        = string
}
