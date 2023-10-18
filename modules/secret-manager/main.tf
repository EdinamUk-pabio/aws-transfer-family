    resource "aws_secretsmanager_secret" "transfer_sftp_secrets" {
        # name = "${var.secret_name}/sftpuser"
        name = "${var.secret_name}"
        recovery_window_in_days  = 0
    }

    resource "random_password" "password" {
        length           = 16
        special          = true
        override_special = "_%@"
    }

    resource "aws_secretsmanager_secret_version" "transfer_sftp_secret_version" {
        secret_id = aws_secretsmanager_secret.transfer_sftp_secrets.id
        secret_string = <<EOF
        {
        "Password": "${random_password.password.result}",
        "Role": "${var.role_arn}",
        "HomeDirectory": "/${var.bucket_name}"
        }
        EOF
    }
