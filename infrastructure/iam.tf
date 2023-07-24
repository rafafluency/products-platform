
resource "aws_iam_role" "iam_for_lambda" {
  name        = "${local.prefix}-products-platform-lambda-role"
  description = "Products Platform role for Lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = [
          "lambda.amazonaws.com",
          "apigateway.amazonaws.com"
        ]
      }
    }]
  })
}

resource "aws_iam_policy" "iam_for_lambda" {
  name        = "${local.prefix}-products-platform-lambda-policy"
  description = "Products Platform policy for Lambda"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "SQS:SendMessage",
          "SQS:ReceiveMessage",
          "SQS:ChangeMessageVisibility",
          "SQS:DeleteMessage",
          "SNS:Publish",
          "SQS:SetQueueAttributes",
          "SQS:GetQueueUrl",
          "SQS:GetQueueAttributes",
          "logs:CreateLogGroup",
          "SNS:*"
        ],
        "Resource" : [
          "arn:aws:lambda:${local.region}:${local.aws_account_id}:function:*",
          "arn:aws:logs:${local.region}:${local.aws_account_id}:*",
          "arn:aws:sns:${local.region}:${local.aws_account_id}:*"
        ]
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "sns:*"
        ],
        "Resource" : "arn:aws:logs:${local.region}:${local.aws_account_id}:log-group:/aws/lambda/*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_for_lambda.arn
}

data "aws_iam_policy" "lambda_ec2_execution_role" {
  arn = "arn:aws:iam::${local.aws_account_id}:policy/AWSLambdaExecutionRoles_EC2_Access"
}

resource "aws_iam_role_policy_attachment" "lambdas_ec2_execution_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = data.aws_iam_policy.lambda_ec2_execution_role.arn
}
