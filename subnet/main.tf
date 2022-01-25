resource "aws_subnet" "subnet" {

    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.subnet_az

    tags = {
        Name = var.subnet_name
        Type = var.subnet_type
    }

    lifecycle {
        prevent_destroy = false
    }
}


resource "aws_route_table_association" "route_table_assoc" {
    subnet_id = aws_subnet.subnet.id
    route_table_id = var.route_table_id

    lifecycle {
        prevent_destroy = false
    }
}

resource "aws_network_acl" "main" {
  vpc_id = var.vpc_id

  egress {
   protocol   = "-1"
   rule_no    = 100
   action     = "allow"
   cidr_block = "0.0.0.0/0"
   from_port  = 0
   to_port    = 0
 }

 ingress {
   protocol   = "-1"
   rule_no    = 100
   action     = "allow"
   cidr_block = "0.0.0.0/0"
   from_port  = 0
   to_port    = 0
 }

  subnet_ids =  [aws_subnet.subnet.id]
  tags = {
    Name = var.subnet_name
  }
}
