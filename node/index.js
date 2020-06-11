require('@babel/register');
const AWS = require('aws-sdk');
const { callApi } = require('./src/api_service');

exports.handler = async function(event, context) {
    await callApi('http://www.google.com');
    await putMessageOnQueue('Hey Jude');
    return 'success'
};


const putMessageOnQueue = async (message) => {
    const sqs = new AWS.SQS({region: process.env.AWS_REGION});
    const sqsQueue = await sqs.getQueueUrl({"QueueName": process.env.AWS_QUEUE}).promise();
    const params = {
        MessageBody: message,
        QueueUrl: sqsQueue.QueueUrl
    };

    await sqs.sendMessage(params).promise();
    console.log('Message put on queue')
};
