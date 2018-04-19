import json, sys, time

input_file = sys.argv[1]
delimiter = sys.argv[2]

with open(input_file) as file:
    loads = []
    for line in file:
        data = line.split(delimiter)

        title = data[0]
        title_link = data[1]
        artists = data[2]
        genres = data[3]
        pubDate = data[4]
        thumb_url = data[5]

        payload = {
            "color": "#36a64f",
            "title": title,
            "title_link": title_link,
            "fields": [
                {
                    "title": "Artists",
                    "value": artists,
                    "short": "true"
                },
                {
                    "title": "Genres",
                    "value": genres,
                    "short": "true"
                },
                {
                    "title": "Publish date",
                    "value": pubDate,
                    "short": "true"
                },
            ],
            "footer": "Best New Music Bot",
            "thumb_url": thumb_url,
            "ts": time.time()
        }
        loads.append(payload)

    message = {
        "username": "best-new-music-bot",
        "icon_emoji": ":p4k:",
        "attachments": loads
    }
    print(json.dumps(message))