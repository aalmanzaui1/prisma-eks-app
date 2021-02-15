resource "aws_security_group" "frontend" {
  provider    = aws.region-master
  name        = "front-rules"
  description = "Allow inbound traffic to front"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "expose app public access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ip-eks-access
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    environment = var.env
    deploy      = var.deploy-name
    name        = "front-rules"
  }
}

resource "aws_security_group" "eks" {
  provider    = aws.region-master
  name        = "eks-control-rules"
  description = "Allow inbound traffic to eks controlplane"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from eks public access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ip-eks-access
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "ALL from private subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.1.3.0/24","10.1.4.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    environment = var.env
    deploy      = var.deploy-name
    name        = "front-rules"
  }
}