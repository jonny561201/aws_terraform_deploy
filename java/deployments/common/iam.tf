//creates a custom policy document with multiple policies applied
data "aws_iam_policy_document" "JavaS3PolicyDoc" {
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
      aws_s3_bucket.JavaLambdaDeploy.arn,
      aws_sqs_queue.JavaSqsQueue.arn,
      aws_cloudwatch_log_group.JavaLambdaCloudWatchGroup.arn
    ]
  }
}

//creates a policy with the document of existing policies applied
resource "aws_iam_policy" "JavaS3Policy" {
  name = "example_policy_${var.deploy_env}-${var.demo_type}"
  path = "/"
  policy = data.aws_iam_policy_document.JavaS3PolicyDoc.json
}

//creates a role with default lambda policies
resource "aws_iam_role" "JavaIAMForLambda" {
  name = "iam_for_lambda_${var.deploy_env}-${var.demo_type}"

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
resource "aws_iam_role_policy_attachment" "JavaS3PolicyAttachment" {
  role = aws_iam_role.JavaIAMForLambda.name
  policy_arn = aws_iam_policy.JavaS3Policy.arn
}