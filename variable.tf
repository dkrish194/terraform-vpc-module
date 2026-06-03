variable "vpc_cidr" {
  description = "vpc cidr range"
  type        = string
  #   default     = "10.0.0.0/16"
}

variable "project" {
  description = "project name"
  type        = string
}
variable "environment" {
  description = "environment name"
  type        = string

}
variable "public_subnets_cidr" {
  description = "public subnets cidr range"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "private subnets cidr range"
  type        = list(string)
}

variable "database_subnets_cidr" {
  description = "database subnets cidr range"
  type        = list(string)
}
