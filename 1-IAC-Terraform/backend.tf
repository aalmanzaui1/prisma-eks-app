terraform {
  backend "s3" {
    bucket = "kops-masterui1"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

