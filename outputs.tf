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
output "public_subnet_ids" {
  description = "public subnets ids"
  value = local.public_subnet_ids
}
# output "private_subnet_ids" {
#   description = "private subnets ids"
#   value = local.private_subnet_ids
# }

output "private_subnet_ids" {
    # value = aws_subnet.private[*].id
    value = [ for item in aws_subnet.private: item.id]
}

output "database_subnet_ids" {
    # value = aws_subnet.database[*].id
    value = [ for item in aws_subnet.database: item.id ]
}

output "database_subnet_group_name" {
    value = aws_db_subnet_group.roboshop.name
}