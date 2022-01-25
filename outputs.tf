output "vpc_id" {
  value = aws_vpc.main.id
}
/*
output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private1a.id
}
*/
output "public1a_subnet_id" {
  value = module.public1a.subnet_id
}

output "public1b_subnet_id" {
  value = module.public1b.subnet_id
}

output "public1c_subnet_id" {
  value = module.public1c.subnet_id
}

output "private1a_subnet_id" {
  value = module.private1a.subnet_id
}

output "private1b_subnet_id" {
  value = module.private1b.subnet_id
}

output "private1c_subnet_id" {
  value = module.private1c.subnet_id
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block
}
