import os

from boto3 import Session

from src.api_service import call_api


# noinspection PyInterpreter
def handle_request(event, context):
    call_api('http://www.google.com')
    __put_message_on_queue('Hey Jude')
    return 'success'


def __put_message_on_queue(message):
    aws_session = Session(region_name=os.environ['AWS_REGION'])
    sqs = aws_session.resource('sqs')
    sqs_queue = sqs.get_queue_by_name(QueueName=os.environ['AWS_QUEUE'])
    sqs_queue.send_message(MessageBody=message)
    print('Message put on queue')
