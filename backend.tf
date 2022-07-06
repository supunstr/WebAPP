terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "app-backend"
    dynamodb_table = "terraform-state-lock-dynamo"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
  }
}