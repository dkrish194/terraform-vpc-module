output "az_names" {
  value = local.az_names
}

output "public_subnets_cidr_az" {
  value = local.public_subnets_cidr_az
}
output "private_subnets_cidr_az" {
  value = local.private_subnets_cidr_az
}
output "databse_subnets_cidr_az" {
  value = local.database_subnets_cidr_az
}
output "vpc_id" {
  description = "vpc id"
  value = aws_vpc.main.id
}