import requests


def call_api(url):
    response = requests.get(url)
    status_code = response.status_code
    print('api call response: ' + str(status_code))
    return status_code

call_api("http://www.google.com")