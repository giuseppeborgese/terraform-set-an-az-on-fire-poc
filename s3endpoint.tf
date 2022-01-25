resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
}
resource "aws_vpc_endpoint_route_table_association" "public1a" {
  route_table_id  = aws_route_table.public1a.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "public1b" {
  route_table_id  = aws_route_table.public1b.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "public1c" {
  route_table_id  = aws_route_table.public1c.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "private1a" {
  route_table_id  = aws_route_table.private1a.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "private1b" {
  route_table_id  = aws_route_table.private1b.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "private1c" {
  route_table_id  = aws_route_table.private1c.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
