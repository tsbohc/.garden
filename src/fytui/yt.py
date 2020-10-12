import json
import grequests
import feedparser
from datetime import datetime

urls = []
rss = []

youtube_channel_ids = [
    'UCvrLvII5oxSWEMEkszrxXEA', # N-O-D-E
    'UC2eYFnH61tmytImy1mTYvhA', # Luke Smith
    ''
]

subreddits = [
    'unixporn'
]

def pretty_print(j):
    print(json.dumps(j, indent=4))

def exception_handler(request, exception):
    print("Request failed", exception)

#for i in youtube_channel_ids:
    #urls.append('http://www.youtube.com/feeds/videos.xml?channel_id=' + i)

for i in subreddits:
    urls.append('https://old.reddit.com/r/' + i + '.rss')

headers = {
    'User-Agent': 'aikrtionrstdirpdrrstd'
}

requests = (grequests.get(u, headers=headers, stream=True) for u in urls)
responces = (grequests.map(requests, exception_handler=exception_handler))

for r in responces:
    # can check url to determine what to extract
    print(r.url)
    if r.status_code != 200:
        continue
    f = feedparser.parse(r.text)

    # youtube parse
    for entry in f['entries']:

        published = entry['published']
        published = published.split('+', 1)[0]
        published = str(datetime.strptime(published, "%Y-%m-%dT%H:%M:%S").timestamp())

        rss.append({
            'type': 'youtube',
            'author': f['feed']['title'],
            'title': entry['title'],
            'summary': entry['summary'],
            'published': published,
            'link': entry['link'],
            'thumbnail': entry['media_thumbnail'][0]['url']
        })

#pretty_print(rss)
