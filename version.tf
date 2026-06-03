terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.8" # aws version
    }
  }
  required_version = ">= 1.8" # ~> terraform version ,consider for patch and minor version upgrade not major

}