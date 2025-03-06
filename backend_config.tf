terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# terraform {
#   backend "s3" {
#     bucket         = "nome-do-bucket-criado" # O bucket criado terá o Account ID adicionado no final.
#     region         = "us-east-1"
#     key            = "terraform/state.tfstate"
#     dynamodb_table = "nome-da-tabela-criada"
#     encrypt        = true
#   }
# }
