
data "aws_iam_policy_document" "sftp_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "sftp-role" {
  name = "${var.role.role_name}-role-${terraform.workspace}"
  # assume_role_policy = file("${path.module}/assume-role.json")
  assume_role_policy = data.aws_iam_policy_document.sftp_assume_role.json
}

resource "aws_iam_role_policy" "sftp-policy" {
  name        = "${var.role.policy_name}-policy-${terraform.workspace}"
  role       = aws_iam_role.sftp-role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
        ],
        Resource = "arn:aws:s3:::${var.bucket_name}"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObjectVersion",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
        ],
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })
}

