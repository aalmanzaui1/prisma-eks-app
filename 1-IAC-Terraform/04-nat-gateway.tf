resource "aws_eip" "eip-natgw" {
  provider = aws.region-master
  vpc      = true

  tags = {
    Name        = "natgw-eip"
    environment = var.env
    deploy      = var.deploy-name
  }
}

resource "aws_nat_gateway" "natgw" {
  provider      = aws.region-master
  allocation_id = aws_eip.eip-natgw.id
  subnet_id     = aws_subnet.subnet-public-1.id

  tags = {
    Name        = "natgw"
    environment = var.env
    deploy      = var.deploy-name
  }
}