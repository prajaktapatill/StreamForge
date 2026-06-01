output "vpc_id" {
  value = aws_vpc.this.id
}
output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}
output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}
output "database_subnet_ids" {
  value = aws_subnet.database.*.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}
