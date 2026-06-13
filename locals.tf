locals {
  common_tags = {
    ManagedBy   = "Terraform"
    project     = var.project
    environment = var.environment
    # Name        = "${var.project}-${var.environment}"
  }

  az_names = slice(sort(data.aws_availability_zones.az_names.names), 0, 2)
  # mapping az to cidr 
  public_subnets_cidr_az = {
    for i, az in local.az_names :
    az => {
      cidr = var.public_subnets_cidr[i]
      az   = az
    }
  }
  private_subnets_cidr_az = {
    for i, az in local.az_names :
    az => {
      cidr = var.private_subnets_cidr[i]
      az   = az
    }
  }
  database_subnets_cidr_az = {
    for i, az in local.az_names :
    az => {
      cidr = var.database_subnets_cidr[i]
      az   = az
    }
  }

  public_subnet_ids= [ for subnet in aws_subnet.public: subnet.id]
  # private_subnet_ids= [ for subnet in aws_subnet.private: subnet.id]

}