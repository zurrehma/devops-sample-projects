# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "k8-infra-terraform-bucket"
    dynamodb_table = "k8-infra-terraform-table"
    encrypt        = true
    key            = "./terraform.tfstate"
    region         = "eu-west-1"
  }
}