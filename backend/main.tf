module "s3_backend" {
  source      = "./s3"
  profile     = var.profile
  region      = var.region
  bucket_name = var.bucket_name
  managed_by  = var.managed_by
  account_id  = var.account_id
}

module "dynamodb_backend" {
  source              = "./dynamodb"
  profile             = var.profile
  region              = var.region
  dynamodb_table_name = var.dynamodb_table_name
  managed_by          = var.managed_by
}
