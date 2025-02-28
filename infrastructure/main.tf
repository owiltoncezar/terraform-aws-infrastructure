module "key-par" {
  source     = "./key-par"
  profile    = "nome-do-profile-configurado-para-o-awscli"
  region     = "regiao-que-deseja-criar-o-recurso"
  name       = "nome-da-chave-key-par"
  public_key = "chave-publica"
  managed_by = "Terraform"
}

module "ec2_instance" {
  source                  = "./ec2"
  name                    = "nome-da-instancia"
  profile                 = "nome-do-profile-configurado-para-o-awscli"
  region                  = "regiao-que-deseja-criar-o-recurso"
  managed_by              = "Terraform"
  ami                     = "id-da-imagem"
  instance_type           = "tipo-da-instância"
  key_name                = module.key-par.key
  disable_api_termination = "true ou false, para proteger contra remoção acidental da instância"
  volume_type             = "tipo-do-ebs"
  volume_size             = "tamanho-do-ebs"
  delete_on_termination   = "true ou false, para que o disco seja deletado junto com a instância"
}
