terraform {
  required_version = "=1.2.8"
  backend "s3" {}
  required_providers {
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.38.0"
    }
  }
}

# config aws provider
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      app-name    = var.app-name
      environment = var.env
      owner       = var.owner
      managed-by  = "terraform"
      create-date = var.timestamp
    }
  }
}

module "s3_files" {
  source = "./modules/s3_files"

  logstash_tf_bucket     = var.logstash_tf_bucket
  logstash_config_prefix = var.logstash_config_prefix
  env                    = var.env
}

module "ec2" {
  source = "./modules/ec2"

  app-name               = var.app-name
  vpc-id                 = var.vpc-id
  region                 = var.region
  env                    = var.env
  account                = var.account
  timestamp              = var.timestamp
  instance_type          = var.instance_type
  ami_value              = var.ami_value
  private_subnet_id      = var.private_subnet_id
  private_subnet_cidr    = var.private_subnet_cidr
  logstash_tf_bucket     = var.logstash_tf_bucket
  logstash_config_prefix = var.logstash_config_prefix
  dir_for_config_files   = var.dir_for_config_files
  infra_alarm_sns_arn    = var.infra_alarm_sns_arn
  dir_for_cwa_files      = var.dir_for_cwa_files
  disk_monitoring_device = var.disk_monitoring_device
}
