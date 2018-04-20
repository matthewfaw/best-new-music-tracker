import json, sys
from urllib.request import urlopen
from urllib.request import Request

delimiter = sys.argv[1]

PITCHFORK_BASE_URL = "https://pitchfork.com"

request = Request(url=PITCHFORK_BASE_URL + '/best/')
response = urlopen(request)
text = response.read().decode('UTF-8').split('window.App=')[1].split(';</script>')[0]
obj = json.loads(text)

content = obj['context']['dispatcher']['stores']['BestNewMusicStore']['bnm']['bnm']

for item in content:
    load = [
        item['title'],
        PITCHFORK_BASE_URL + item['url'],
        ", ".join([artist['display_name'] for artist in item['artists']]),
        ", ".join([artist['display_name'] for artist in item['genres']]),
        item['pubDate'],
        item['tombstone']['albums'][0]['album']['photos']['tout']['sizes']['homepageLarge'],
        ", ".join([author['name'] for author in item['authors']]),
        ""
    ]
    print(delimiter.join(load))