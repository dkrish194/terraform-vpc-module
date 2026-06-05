resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-igw"
  })
}

resource "aws_eip" "eip" {
  domain = "vpc" //   us-east-1 
 tags          = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}-eip"
  })
}
resource "aws_nat_gateway" "nat_gw" {
  count = var.is_NAT_required ? 1 : 0
  allocation_id = aws_eip.eip.id // Elastic Ip which we created
  subnet_id     = aws_subnet.public["us-east-1a"].id
  tags          = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}-nat_gw"
  })


}

resource "aws_subnet" "public" {
  for_each                = local.public_subnets_cidr_az
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az // don't use availability_zone_id not support in all region
  map_public_ip_on_launch = true          // instance gets publci ip
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-public"
  })
}




resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id // only vpc
  //  no need to give route table name and routing rules here
  // route rules we can define using "aws_route" resource
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-public"
  })
}
// Add subnets to route table
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public // assigned complete list of items
  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id // from item.id
}

// create Rules in RT, destination and gateway (via)
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


// create Private Route Table ,Route table Association and Rules
resource "aws_subnet" "private" {
  for_each                = local.private_subnets_cidr_az
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az // don't use availability_zone_id not support in all region
  map_public_ip_on_launch = true          // instance gets publci ip
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-private"
  })
}
//create Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id // only vpc
  //  no need to give route table name and routing rules here
  // route rules we can define using "aws_route" resource
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-private"
  })
}

// Add subnets to route table
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private // assigned complete list of items
  route_table_id = aws_route_table.private.id
  subnet_id      = each.value.id // from item.id
}

// create Rules in RT, destination and gateway (via)
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gw.id

}


resource "aws_subnet" "database" {
  for_each                = local.database_subnets_cidr_az
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az // don't use availability_zone_id not support in all region
  map_public_ip_on_launch = true          // instance gets publci ip
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-database"
  })
}
//create Route Table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id // only vpc
  //  no need to give route table name and routing rules here
  // route rules we can define using "aws_route" resource
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-database"
  })
}

// Add subnets to route table
resource "aws_route_table_association" "database" {
  for_each       = aws_subnet.database // assigned complete list of items
  route_table_id = aws_route_table.database.id
  subnet_id      = each.value.id // from item.id
}

// create Rules in RT, destination and gateway (via)
resource "aws_route" "database" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gw.id
  
}