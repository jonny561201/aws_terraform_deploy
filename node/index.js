require('@babel/register');
const { call_api } = require('./src/api_service');

exports.handler = async function(event) {
    await call_api('http://www.google.com')
    return 'success'
}

exports.handler({});