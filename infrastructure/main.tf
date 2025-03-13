module "key-par" {
  source     = "./key-par"
  profile    = var.profile
  region     = var.region
  name       = var.name
  public_key = var.public_key
  managed_by = var.managed_by
}

module "ec2_instance" {
  source        = "./ec2"
  profile       = var.profile
  region        = var.region
  managed_by    = var.managed_by
  ami           = var.ami
  key_name      = module.key-par.key
  name          = var.name
  instance_type = var.instance_type
  volume_type   = var.volume_type
  volume_size   = var.volume_size
  kms_key_id    = var.kms_key_id

  depends_on = [module.key-par]
}
