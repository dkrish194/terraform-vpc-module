resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}"
  })
}

resource "aws_subnet" "public" {
    for_each = local.public_subnets_cidr_az
  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az // don't use availability_zone_id not support in all region
  map_public_ip_on_launch = true // instance gets publci ip
  tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}"
  })
}

resource "aws_subnet" "private" {
    for_each = local.private_subnets_cidr_az
  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az // don't use availability_zone_id not support in all region
  map_public_ip_on_launch = true // instance gets publci ip
  tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}"
  })
}
resource "aws_subnet" "database" {
    for_each = local.database_subnets_cidr_az
  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az // don't use availability_zone_id not support in all region
  map_public_ip_on_launch = true // instance gets publci ip
  tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}"
  })
}

