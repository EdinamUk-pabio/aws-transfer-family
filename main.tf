module "s3_bucket" {
 source = "./modules/s3"
 bucket_name = var.s3_bucket_settings.bucket_name
 bucket_versioning = var.s3_bucket_settings.bucket_versioning
}


module "auth-lambda" {
  source = "./modules/lambda"
  identifier = var.auth_lambda.name
  lambda_policy = var.auth_lambda.policy_document
  runtime = var.auth_lambda.runtime
  environment_variables = var.auth_lambda.environment_variables
  timeout = var.auth_lambda.timeout

  depends_on = [ module.s3_bucket ]
}


module "sftp-server" {
  source = "./modules/transfer-family"
  lambda_function_arn = module.auth-lambda.lambda.arn
  endpoint_type = var.sftp_settings.endpoint_type
  identity_provider_type = var.sftp_settings.identity_provider_type
  storage_domain = var.sftp_settings.storage_domain
  sftp-log-group = var.sftp_settings.sftp-log-group

  depends_on = [ module.auth-lambda ]
}


module "users_permission" {
    source = "./modules/role"
    role = var.sftp_users_role
    bucket_name = module.s3_bucket.s3.bucket
    
    depends_on = [ module.s3_bucket ]
}

#SFTP users are manage by secret manager
module "sftp_users" {
  for_each = {for key, value in var.sftp_users: key => value}
  source = "./modules/secret-manager"
  secret_name = each.value.user_secret
  bucket_name = module.s3_bucket.s3.bucket
  role_arn = module.users_permission.role_arn.arn

  depends_on = [ module.s3_bucket, module.users_permission ]
}


resource "aws_lambda_permission" "transfer_sftp_lambda_invoke" {
    statement_id  = "sftp-transfer-family-invoke"
    action        = "lambda:InvokeFunction"
    function_name = module.auth-lambda.lambda.arn
    principal     = "transfer.amazonaws.com"
    source_arn    = module.sftp-server.sftp-server-id.arn
}