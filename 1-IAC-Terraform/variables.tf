variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "eu-west-1"
}

variable "env" {
  type        = string
  description = "type of enviroment dev or prod"
}

variable "deploy-name" {
  type        = string
  description = "set a deployment name"
}

variable "vpc-cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "ip-eks-access" {
  type = list(string)
  description =  "SET THIS WITH A SECURE PUBLIC IP"
  default = ["0.0.0.0/0"]
}

variable "eks-public-access" {
  type    = bool
  default = true
}

variable "AWS_ACCOUNT_ID"{
  type    = string
  default = "111111111111"
}

variable "access_key" {
  type    = string
  default = ""
}

variable "secret_key" {
  type    = string
  default = ""
}
# variable "availability_zone_names" {
#   type    = list(string)
#   #default = ["us-west-1a"]
# }
