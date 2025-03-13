# Obtém o ID da conta AWS
data "aws_caller_identity" "current" {}

# Obtém a AMI mais recente do Ubuntu (versão mais nova disponível)
data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners      = ["099720109477"] # ID oficial da Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Módulo de backend (S3 e DynamoDB)
module "backend" {
  source              = "./backend"
  profile             = var.profile
  region              = var.region
  managed_by          = var.managed_by
  bucket_name         = var.bucket_name
  dynamodb_table_name = var.dynamodb_table_name
  account_id          = data.aws_caller_identity.current.account_id
}

# Módulo de infraestrutura (key-pair e EC2)
module "infrastructure" {
  source        = "./infrastructure"
  profile       = var.profile
  region        = var.region
  managed_by    = var.managed_by
  name          = var.name
  public_key    = var.public_key
  instance_type = var.instance_type
  volume_size   = var.volume_size
  volume_type   = var.volume_type
  ami           = data.aws_ami.ubuntu_latest.id
  kms_key_id    = var.kms_key_id
}
