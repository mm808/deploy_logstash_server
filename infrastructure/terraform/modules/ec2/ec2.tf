#Create key-pair for ssh into server
resource "aws_key_pair" "logstash-server-key" {
  key_name   = "logstash-server-key-${var.env}"
  public_key = file("modules/ec2/logstash_server_key.pub")
}

resource "aws_security_group" "logstash_server_secgrp" {
  name = "logstash_server-sg-${var.env}"
  description = "Security group for logstash server"
  vpc_id      = "${var.vpc-id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }
}

# master template for user_data
data "cloudinit_config" "server" {
  gzip = false
  base64_encode = false
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/template_files/install_logstash.tpl", {})
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/template_files/config_logstash.tpl", {logstash_tf_bucket = var.logstash_tf_bucket
    logstash_config_prefix = var.logstash_config_prefix
    dir_for_config_files = var.dir_for_config_files})
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/template_files/install_cloudwatch_agent.tpl", {logstash_tf_bucket = var.logstash_tf_bucket 
    logstash_config_prefix = var.logstash_config_prefix
    dir_for_cwa_files = var.dir_for_cwa_files
    region = var.region})
  }
}

resource "aws_instance" "logstash-server" {
  ami                         = var.ami_value
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.logstash-server-key.key_name
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.logstash_server_secgrp.id]
  subnet_id                   = var.private_subnet_id
  root_block_device {
    tags        = {
      name = "logstash-server-${var.env}-disk"
    }
    volume_size = 20
    volume_type           = "gp2"
    delete_on_termination = false
  }
  iam_instance_profile = aws_iam_instance_profile.server_profile.name
  
  tags = {
    Name = "logstash_server_${var.env}"
  }
  
  user_data = data.cloudinit_config.server.rendered
}

