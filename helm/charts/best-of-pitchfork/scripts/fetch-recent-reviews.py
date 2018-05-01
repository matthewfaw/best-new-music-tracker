import json, sys
from urllib.request import urlopen
from urllib.request import Request

delimiter = sys.argv[1]
post_type = sys.argv[2] # bnr, bnm, bnt

PITCHFORK_BASE_URL = "https://pitchfork.com"

request = Request(url=PITCHFORK_BASE_URL + '/best/')
response = urlopen(request)
text = response.read().decode('UTF-8').split('window.App=')[1].split(';</script>')[0]
obj = json.loads(text)

content = obj['context']['dispatcher']['stores']['BestNewMusicStore']['bnm'][post_type ]

for item in content:
    image_url = ""
    if post_type == "bnt":
        image_url = item['photos']['tout']['sizes']['homepageLarge']
    else:
        image_url = item['tombstone']['albums'][0]['album']['photos']['tout']['sizes']['homepageLarge']
    load = [
        item['title'],
        PITCHFORK_BASE_URL + item['url'],
        ", ".join([artist['display_name'] for artist in item['artists']]),
        ", ".join([artist['display_name'] for artist in item['genres']]),
        item['pubDate'],
        image_url,
        ", ".join([author['name'] for author in item['authors']]),
        ""
    ]
    print(delimiter.join(load))