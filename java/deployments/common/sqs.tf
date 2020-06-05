//create sqs queue
resource "aws_sqs_queue" "JavaSqsQueue" {
  name = "${var.demo_type}-${var.deploy_env}-queue-coaching-demo"
  max_message_size = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}
