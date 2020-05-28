from boto3 import Session

from src.api_service import get_google_response

REGION = 'us-east-1'
QUEUE = 'jgraf-awesome-queue'


#event.body
def test_function(event, context):
    get_google_response()
    sqs_queue = __get_sqs_queue()
    sqs_queue.send_message(MessageBody='hey Jude')
    return 'success'


def __get_sqs_queue():
    aws_session = Session(region_name=REGION)
    sqs = aws_session.resource('sqs')
    return sqs.get_queue_by_name(QueueName=QUEUE)
