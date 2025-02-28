terraform {
  backend "s3" {
    bucket         = "terraform-states-440744240874"
    region         = "us-east-1"
    key            = "terraform/state.tfstate"
    dynamodb_table = "terraform-states-lock"
    encrypt        = true
  }
}
