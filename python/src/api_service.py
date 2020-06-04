import requests


def call_api(url):
    response = requests.get(url)
    content = response.content
    print('api call response: ' + content)
    return content
