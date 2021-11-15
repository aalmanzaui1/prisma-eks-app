resource "aws_vpc" "main" {
  provider             = aws.region-master
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    environment                                = var.env
    deploy                                     = var.deploy-name
    "kubernetes.io/cluster/${var.deploy-name}" = "shared"
  }
}