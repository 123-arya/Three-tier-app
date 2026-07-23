provider "aws" {
  region = local.region
}


data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  region         = var.aws_region
  name           = var.cluster_name
  vpc_cidr       = var.vpc_cidr
  azs            = slice(data.aws_availability_zones.available.names, 0, var.total_azs)
  private_subnets = var.private_subnet
  public_subnets  = var.public_subnet   

  tags = {
    Project   = "skillpulse"
    Managedby = "terraform"
  }
}
