resource "aws_iam_role" "lambda_roles" {
  name = "${var.identifier}-${terraform.workspace}-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy_attachement" {
  role       = aws_iam_role.lambda_roles.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "${var.identifier}-${terraform.workspace}-lambda"
  description = "Policy for Lambda function ${var.identifier}"
  policy      = var.lambda_policy
}

resource "aws_iam_policy_attachment" "multiple_policies_attachment" {
  name       = "${var.identifier}-${terraform.workspace}-policy-attachment"
  policy_arn = aws_iam_policy.lambda_policy.arn
  roles      = [aws_iam_role.lambda_roles.name]
}

data "archive_file" "lambad_code_zip" {
  type        = "zip"
  source_dir  = "${path.root}/modules/lambda/code/${var.identifier}"
  output_path = "${path.root}/modules/lambda/code/${var.identifier}.zip"
}


resource "aws_lambda_function" "lambda_functions" {
  filename      = "${path.root}/modules/lambda/code/${var.identifier}.zip"
  function_name = "${var.identifier}-${terraform.workspace}"
  role          = aws_iam_role.lambda_roles.arn
  handler       = "main.lambda_handler"
  runtime       = var.runtime
  timeout       = var.timeout


  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  #   layers        = local.layer_arns
  #   environment {
  #     variables = {
  #       foo = "bar"
  #     }
  #   }

}
