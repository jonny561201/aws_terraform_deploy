const https = require('https')
let url = "https://docs.aws.amazon.com/lambda/latest/dg/welcome.html"

exports.handler = async function(event) {
    console.log("EVENT: \n" + JSON.stringify(event, null, 2))
    const promise = new Promise(function(resolve, reject) {
        https.get(url, (res) => {
            resolve(res.statusCode)
        }).on('error', (e) => {
            reject(Error(e))
        })
    })
    return promise
}