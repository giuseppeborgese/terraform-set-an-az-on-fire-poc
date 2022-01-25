data "aws_region" "current" {}

# The VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = var.vpc_name
      Environment = var.environment
    }

    lifecycle {
        prevent_destroy = false
    }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name} IGW"
    }
    lifecycle {
        prevent_destroy = false
    }
}


# Routing Tables
resource "aws_route_table" "public1a" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name} Public Routes A"
    }
    lifecycle {
        prevent_destroy = false
    }
}

resource "aws_route_table" "public1b" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name} Public Routes B"
    }
    lifecycle {
        prevent_destroy = false
    }
}

resource "aws_route_table" "public1c" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name} Public Routes C"
    }
    lifecycle {
        prevent_destroy = false
    }
}


resource "aws_route_table" "private1a" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name} Private Route for 1A"
    }
    lifecycle {
        prevent_destroy = false
    }
}

resource "aws_route_table" "private1b" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name} Private Route for 1B"
    }
    lifecycle {
        prevent_destroy = false
    }
}
resource "aws_route_table" "private1c" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name} Private Route for 1C"
    }
    lifecycle {
        prevent_destroy = false
    }
}

# Outgoing route for public Subnets
resource "aws_route" "public_internet1a" {
  route_table_id = aws_route_table.public1a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route" "public_internet1b" {
  route_table_id = aws_route_table.public1b.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route" "public_internet1c" {
  route_table_id = aws_route_table.public1c.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}


# Subnets
#

# Public
module "public1a" {
  source = "./subnet/"

  vpc_id = aws_vpc.main.id
  subnet_cidr_block = var.cidr_pub_1a
  subnet_az = "${data.aws_region.current.name}a"
  subnet_name = "public 1A"
  subnet_type = "Public"
  route_table_id = aws_route_table.public1a.id
}

module "public1b" {
  source = "./subnet/"

  vpc_id = aws_vpc.main.id
  subnet_cidr_block = var.cidr_pub_1b
  subnet_az = "${data.aws_region.current.name}b"
  subnet_name = "public 1B"
  subnet_type = "Public"
  route_table_id = aws_route_table.public1b.id
}

module "public1c" {
  source = "./subnet/"

  vpc_id = aws_vpc.main.id
  subnet_cidr_block = var.cidr_pub_1c
  subnet_az = "${data.aws_region.current.name}c"
  subnet_name = "public 1C"
  subnet_type = "Public"
  route_table_id = aws_route_table.public1c.id
}

# Private Subnets

module "private1a" {
  source = "./subnet/"

  vpc_id = aws_vpc.main.id
  subnet_cidr_block = var.cidr_priv_1a
  subnet_az = "${data.aws_region.current.name}a"
  subnet_name = "private 1A"
  subnet_type = "Private"
  route_table_id = aws_route_table.private1a.id
}

module "private1b" {
  source = "./subnet/"

  vpc_id = aws_vpc.main.id
  subnet_cidr_block = var.cidr_priv_1b
  subnet_az = "${data.aws_region.current.name}b"
  subnet_name = "private 1B"
  subnet_type = "Private"
  route_table_id = aws_route_table.private1b.id
}

module "private1c" {
  source = "./subnet/"

  vpc_id = aws_vpc.main.id
  subnet_cidr_block = var.cidr_priv_1c
  subnet_az = "${data.aws_region.current.name}c"
  subnet_name = "private 1C"
  subnet_type = "Private"
  route_table_id = aws_route_table.private1c.id
}
