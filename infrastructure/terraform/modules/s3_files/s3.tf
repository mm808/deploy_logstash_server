resource "aws_s3_object" "company_api_lblogs_config" {
    bucket  = "${var.logstash_tf_bucket}"
    key     =  "${var.logstash_config_prefix}/${var.env}_company_api_lblogs.conf"
    source = "server_config_files/${var.env}_company_api_lblogs.conf"
    etag = filemd5("server_config_files/${var.env}_company_api_lblogs.conf")
}

resource "aws_s3_object" "cloudwatch_agent_config" {
    bucket  = "${var.logstash_tf_bucket}"
    key     =  "${var.logstash_config_prefix}/config.json"
    source = "server_config_files/config.json"
    etag = filemd5("server_config_files/config.json")
}