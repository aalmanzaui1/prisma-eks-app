resource "aws_route_table" "public" {
  provider = aws.region-master
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name        = "route-table-public"
    environment = var.env
    deploy      = var.deploy-name
  }
}

resource "aws_default_route_table" "default-rt" {
  provider               = aws.region-master
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name        = "route-table-public"
    environment = var.env
    deploy      = var.deploy-name
  }
}

resource "aws_route_table_association" "public-association-1" {
  provider       = aws.region-master
  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-association-2" {
  provider       = aws.region-master
  subnet_id      = aws_subnet.subnet-public-2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-association-1" {
  provider       = aws.region-master
  subnet_id      = aws_subnet.subnet-private-3.id
  route_table_id = aws_default_route_table.default-rt.id
}

resource "aws_route_table_association" "private-association-2" {
  provider       = aws.region-master
  subnet_id      = aws_subnet.subnet-private-4.id
  route_table_id = aws_default_route_table.default-rt.id
}