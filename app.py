from boto3 import Session

from src.test import get_google_response

REGION = 'us-east-2'
QUEUE = 'jgraf-awesome-queue'


def test_function(event, context):
    get_google_response()
    aws_session = Session(region_name=REGION)
    sqs = aws_session.resource('sqs')
    sqs_queue = sqs.get_queue_by_name(QueueName=QUEUE)
    print('SQS url:' + sqs_queue.url)

    sqs_queue.send_message(MessageBody='hey Jude')
    return 'success'
