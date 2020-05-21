resource "aws_s3_bucket" "alb" {
    bucket = "kt-user11-alb-log.com"
    policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Principal": {
"AWS": "arn:aws:iam::${var.ALB_ACCOUNT_ID}:root"
},
"Action": "s3:PutObject",
"Resource": "arn:aws:s3:::kt-user11-alb-log.com/*"
}
]
}
EOF
    
    lifecycle_rule {
        id = "log_lifecycle"
        prefix = ""
        enabled = true
        transition {
            days = 30
            storage_class = "GLACIER"
        }

        expiration {
            days = 90
        }
    }

    lifecycle {
        prevent_destroy = false
    }
}