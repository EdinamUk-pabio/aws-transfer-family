s3_bucket_settings = {
    bucket_name = "stfp-bucket-testing-akbar"
    bucket_versioning = "Enabled"
}


auth_lambda = {
  name = "auth-lambda-test"
  runtime         = "python3.9"
  timeout         = 900
  environment_variables = {
    SecretsManagerRegion = "us-east-1"
  }
  policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource" : "*"
    }
  ]
}
EOF

}

sftp_settings = {
    endpoint_type = "PUBLIC"
    identity_provider_type = "AWS_LAMBDA"
    storage_domain = "S3"
    sftp-log-group = "sftp-server-lambda-auth"
}

sftp_users_role = {
    policy_name = "sftp-users-policy"
    role_name = "sftp-users-role"
}

sftp_users = [
    {
    user_secret = "ali"
    },
    {
     user_secret = "ahmed"
    },
    {
      user_secret = "alam"
    }
]
