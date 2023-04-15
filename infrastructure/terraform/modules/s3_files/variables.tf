variable "env" {
  description = "environment we are deploying to"
  type        = string
}

variable "logstash_tf_bucket" {
  description = "logstash_tf_bucket"
  type        = string
}

variable "logstash_config_prefix" {
  description = "logstash_tf_bucket config prefix"
  type        = string
  default     = "deploy_logstash/config_files"
}
