data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}


resource "aws_subnet" "subnet-public-1" {
  provider   = aws.region-master
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.1.0/24"

  availability_zone = element(data.aws_availability_zones.azs.names, 0)

  tags = {
    Name        = "subnet-public-1"
    environment = var.env
    deploy      = var.deploy-name
    "kubernetes.io/role/elb" = 1
    "kubernetes.io/cluster/${var.deploy-name}" = "shared"
  }
}

resource "aws_subnet" "subnet-public-2" {
  provider   = aws.region-master
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.2.0/24"

  availability_zone = element(data.aws_availability_zones.azs.names, 1)

  tags = {
    Name        = "subnet-public-2"
    environment = var.env
    deploy      = var.deploy-name
    "kubernetes.io/role/elb" = 1
    "kubernetes.io/cluster/${var.deploy-name}" = "shared"
  }
}

resource "aws_subnet" "subnet-private-3" {
  provider   = aws.region-master
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.3.0/24"

  availability_zone = element(data.aws_availability_zones.azs.names, 0)

  tags = {
    Name        = "subnet-private-3"
    environment = var.env
    deploy      = var.deploy-name
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/${var.deploy-name}" = "shared"
  }
}

resource "aws_subnet" "subnet-private-4" {
  provider   = aws.region-master
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.4.0/24"

  availability_zone = element(data.aws_availability_zones.azs.names, 1)

  tags = {
    Name        = "subnet-private-4"
    environment = var.env
    deploy      = var.deploy-name
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/${var.deploy-name}" = "shared"
  }
}