# role server can assume to do stuff
resource "aws_iam_role" "server_role" {
  name               = "logstash_server_role_${var.env}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}

# policy allowing  server access to s3 and OSS
resource "aws_iam_role_policy" "server_policy" {
  name     = "logstash_${var.env}_server_policy"
  role     = aws_iam_role.server_role.id
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "es:ESHttpHead",
            "es:ESHttpPost",
            "es:ESHttpPatch",
            "es:ESHttpGet",
            "es:ESHttpPut"
        ],
        "Resource": "arn:aws:es:*:${var.account}:domain/company-elastic-search-${var.env}"
      },
      {
        "Effect": "Allow",
        "Action": [
            "es:ListElasticsearchInstanceTypeDetails",
            "es:ListDomainsForPackage",
            "es:ListInstanceTypeDetails",
            "es:ListVersions",
            "es:ListDomainNames"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
            "cloudwatch:PutMetricData",
            "ec2:DescribeVolumes",
            "ec2:DescribeTags",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams",
            "logs:DescribeLogGroups",
            "logs:CreateLogStream",
            "logs:CreateLogGroup"
        ],
        "Resource": "*"
      },
      {  
        "Effect": "Allow",
        "Action": [
          "s3:List*",
          "s3:Get*"
          ],
        "Resource": [
          "arn:aws:s3:::connectapi-elb-${var.env}",
          "arn:aws:s3:::connectapi-elb-${var.env}/*",
          "arn:aws:s3:::connect-cloudfront-logs-customer-${var.env}",
          "arn:aws:s3:::connect-cloudfront-logs-customer-${var.env}/*",
          "arn:aws:s3:::terraformstatebucket-${var.env}",
          "arn:aws:s3:::terraformstatebucket-${var.env}/deploy_logstash/config_files/*"
        ]
      }
  ]
}
EOF
}

#instance profile for server
resource "aws_iam_instance_profile" "server_profile" {
  name     = "logstash_server_profile_${var.env}"
  role     = aws_iam_role.server_role.name
}
