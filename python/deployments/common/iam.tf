//creates a custom policy document with multiple policies applied
data "aws_iam_policy_document" "s3_policy_doc" {
  statement {
    sid = "1"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "sqs:SendMessage",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      aws_s3_bucket.lambda_deploy.arn,
      aws_sqs_queue.terraform_queue.arn,
      aws_cloudwatch_log_group.lambda-cloudwatch-group.arn
    ]
  }
}

//creates a policy with the document of existing policies applied
resource "aws_iam_policy" "s3_policy" {
  name = "example_policy_${var.deploy_env}"
  path = "/"
  policy = data.aws_iam_policy_document.s3_policy_doc.json
}

//creates a role with default lambda policies
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_${var.deploy_env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

//attaches my custom policy to my basic lambda role
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.s3_policy.arn
}