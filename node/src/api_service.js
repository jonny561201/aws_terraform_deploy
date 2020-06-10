import fetch from 'node-fetch';

export const call_api = async (url) => {
    const requestOptions = {
        method: "GET"
    };
    const response = await fetch(url, requestOptions);
    console.log('api call response: ' + response.status);
    return response.status;
};