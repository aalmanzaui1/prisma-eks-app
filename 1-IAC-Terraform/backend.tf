/*terraform {
  backend "s3" {
    bucket = "almanzabucket1"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
*/
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}
