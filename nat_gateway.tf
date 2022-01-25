resource "aws_nat_gateway" "gw_public1a" {
  allocation_id = aws_eip.gw_public1a.id
  subnet_id     = module.public1a.subnet_id

  tags = {
    Name = "NAT public 1A"
  }
}
resource "aws_eip" "gw_public1a" {
  vpc      = true
}
resource "aws_route" "internet_private1a" {
  route_table_id = aws_route_table.private1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.gw_public1a.id
}

#########
resource "aws_nat_gateway" "gw_public1b" {
  allocation_id = aws_eip.gw_public1b.id
  subnet_id     = module.public1b.subnet_id

  tags = {
    Name = "NAT public 1B"
  }
}
resource "aws_eip" "gw_public1b" {
  vpc      = true
}
resource "aws_route" "internet_private1b" {
  route_table_id = aws_route_table.private1b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.gw_public1b.id
}
###########

resource "aws_nat_gateway" "gw_public1c" {
  allocation_id = aws_eip.gw_public1c.id
  subnet_id     = module.public1c.subnet_id

  tags = {
    Name = "NAT public 1C"
  }
}
resource "aws_eip" "gw_public1c" {
  vpc      = true
}
resource "aws_route" "internet_private1c" {
  route_table_id = aws_route_table.private1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.gw_public1c.id
}
