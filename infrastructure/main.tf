terraform {
  backend "s3" {
    bucket = "enterprise-applications-terraform"
    key    = "products-platform.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.2.6"
}

provider "aws" {
  access_key = var.access_key_list[terraform.workspace]
  secret_key = var.secret_key_list[terraform.workspace]
  region     = var.region
}

data "aws_caller_identity" "current" {}

variable "access_key_list" {
  type = map(any)
}

variable "secret_key_list" {
  type = map(any)
}

variable "region" {
  default = "us-east-1"
}

variable "aws_account_id_list" {
  type = map(any)
}

variable "db_username_list" {
  type = map(any)
}

variable "db_password_list" {
  type = map(any)
}

locals {
  team_prefix     = "ea"
  prefix          = "${local.team_prefix}-${terraform.workspace}"
  days_in_seconds = 60 * 60 * 24
  aws_tag_environment = {
    staging = "Staging"
    prod    = "Prod"
  }
  tags = {
    Environment = local.aws_tag_environment[terraform.workspace]
    Product     = "Products Platform"
    Application = "Products Platform"
    Project     = "Products Platform"
    Team        = "Enterprise Applications"
  }
  vpcs = {
    staging = "vpc-03357a1b341a2a305"
    prod    = "vpc-06b0b94970652496d"
  }
  vpc                         = local.vpcs[terraform.workspace]
  region                      = var.region
  lambda_subnets_internet_ids = ["subnet-0542fac9119bf7fd0", "subnet-0d090d2576f9ac48f"]
  lambda_sg_internet_ids      = ["sg-00590bb090239e3cc"]
  enable_alerts_list = {
    staging = 0
    prod    = 1
  }
  enable_alerts      = local.enable_alerts_list[terraform.workspace]
  is_prod            = terraform.workspace == "prod" ? 1 : 0
  is_prod_vpc_config = terraform.workspace == "prod" ? [1] : []
  db_username = var.db_username_list[terraform.workspace]
  db_password = var.db_password_list[terraform.workspace]

  logstash_host_list = {
    staging = "elk.fluency.io:50000"
    prod    = "elk.fluency.io:50000"
  }
  logstash_host = local.logstash_host_list[terraform.workspace]

  aws_account_id = data.aws_caller_identity.current.account_id
}
