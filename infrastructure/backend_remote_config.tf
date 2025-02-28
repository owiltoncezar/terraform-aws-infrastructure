terraform {
  backend "s3" {
    bucket         = "nome-do-bucket-criado"
    region         = "us-east-1"
    key            = "terraform/state.tfstate"
    dynamodb_table = "nome-da-tabela-criada"
    encrypt        = true
  }
}