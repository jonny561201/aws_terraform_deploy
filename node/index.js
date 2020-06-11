require('@babel/register');
const AWS = require('aws-sdk');
const { call_api } = require('./src/api_service');

exports.handler = async function(event, context) {
    await call_api('http://www.google.com');
    await putMessageOnQueue('Hey Jude');
    return 'success'
};


const putMessageOnQueue = async (message) => {
    const sqs = new AWS.SQS({region : process.env.AWS_REGION});
    const sqsQueue = sqs.getQueueUrl({"QueueName": process.env.AWS_QUEUE}).promise().then(data => {
        console.log('QUEUE Url:', data);
    });
    const params = {
        MessageBody: message,
        QueueUrl: sqsQueue
    };
    await sqs.sendMessage(params, () => console.log('Message put on queue'));
};
