module "s3_backend" {
  source      = "./s3"
  profile     = "nome-do-profile-configurado-para-o-awscli"
  region      = "regiao-que-deseja-criar-o-recurso"
  bucket_name = "nome-do-bucket-para-armazenar-os-states-do-terraform"
  state_key   = "terraform/state.tfstate"
  managed_by  = "Terraform"
  account_id  = "id da conta da aws"
}

module "dynamodb_backend" {
  source              = "./dynamodb"
  profile             = "nome-do-profile-configurado-para-o-awscli"
  region              = "regiao-que-deseja-criar-o-recurso"
  dynamodb_table_name = "nome-da-tabela-para-armazenar-os-states-lock"
  managed_by          = "Terraform"
}
