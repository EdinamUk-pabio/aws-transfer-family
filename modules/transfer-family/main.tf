# data "aws_iam_role" "logging-role"{
#         name = "AWSTransferLoggingAccess"
#     }

resource "aws_cloudwatch_log_group" "transfer" {
  name_prefix = "${var.sftp-log-group}-${terraform.workspace}"
}

data "aws_iam_policy_document" "transfer_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_transfer" {
  name_prefix         = "iam_for_transfer_"
  assume_role_policy  = data.aws_iam_policy_document.transfer_assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSTransferLoggingAccess"]
}


resource "aws_transfer_server" "sftp" {
    endpoint_type = var.endpoint_type #"PUBLIC"
    logging_role  = aws_iam_role.iam_for_transfer.arn
    identity_provider_type = var.identity_provider_type #"AWS_LAMBDA"
    function = var.lambda_function_arn
    domain                          = var.storage_domain #"S3"
    # pre_authentication_login_banner = "SFTP Server - Managed by DevOps "
    protocols                       = ["SFTP"]

     structured_log_destinations = [
    "${aws_cloudwatch_log_group.transfer.arn}:*"
  ]

}
