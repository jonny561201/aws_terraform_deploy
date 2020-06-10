require('@babel/register');
const AWS = require('aws-sdk');
const { call_api } = require('./src/api_service');

exports.handler = async function(event, context) {
    await call_api('http://www.google.com');
    putMessageOnQueue('Hey Jude');
    return 'success'
};


const putMessageOnQueue = (message) => {
    const sqs = new AWS.SQS({region : 'us-east-1'});
    const sqsQueue = sqs.getQueueUrl({"QueueName": process.env.AWS_QUEUE}).promise();
    const params = {
        MessageBody: message,
        QueueUrl: sqsQueue
    };
    sqs.sendMessage(params, () => console.log('Message put on queue'));
};
