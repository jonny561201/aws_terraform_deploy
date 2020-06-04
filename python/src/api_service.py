import requests


def get_google_response():
    url = 'https://www.google.com'
    response = requests.get(url)
    return response.content
