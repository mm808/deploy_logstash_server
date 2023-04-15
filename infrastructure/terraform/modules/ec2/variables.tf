variable "env" {
  description = "environment we are deploying to"
  type        = string
}

variable "app-name" {
  description = "app name"
  type        = string
}

variable "region" {
  description = "aws region"
  type        = string
}

variable "timestamp" {
  description = "date tag"
  type        = string
}

variable "owner" {
  description = "app owner"
  type        = string
  default     = "ConnectTeam"
}

variable "account" {
  description = "aws account id"
  type        = string
}

variable "vpc-id" {
  description = "vpc id"
  type        = string
}

variable "instance_type" {
  description = "ec2 type"
  type = string
}

variable "ami_value" {
  description = "ami for the Ubuntu 20.22 server"
  type = string
}

variable "private_subnet_id" {
  description = "private_subnet_id of server"
  type        = string
}

variable "private_subnet_cidr" {
  description = "cidr of priv subnet"
  type = string
}

variable "logstash_tf_bucket" {
  description = "logstash_tf_bucket"
  type = string
}

variable "logstash_config_prefix" {
  description = "logstash_tf_bucket config prefix"
  type        = string
  default = "deploy_logstash/config_files"
}

variable "dir_for_config_files" {
  description = "dir_for_config_files on server"
  type        = string
  default     = "/etc/logstash/conf.d"
}

variable "dir_for_cwa_files" {
  description = "dir for cloudwatch config files"
  type        = string
  default     = "/opt/aws/amazon-cloudwatch-agent/bin"
}

variable "infra_alarm_sns_arn" {
  description = "sns topic to alert on alarm"
  type = string
}

variable "disk_monitoring_device" {
  description = "disk device name"
  type = string
}
