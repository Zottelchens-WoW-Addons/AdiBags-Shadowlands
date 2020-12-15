import os

import requests

CLIENT_ID = os.environ['BLIZZ_ID']
CLIENT_SECRET = os.environ['BLIZZ_SECRET']


def get_access(REGION='eu'):
    # get access-token
    data = {
        'grant_type': 'client_credentials'
    }
    r = requests.post('https://' + REGION + '.battle.net/oauth/token', data=data, auth=(CLIENT_ID, CLIENT_SECRET))
    return r.json()["access_token"]
