import json
import subprocess
import grequests
import feedparser
from datetime import datetime
import time

urls = []
rss = []

youtube_channel_ids = [
    'UCvrLvII5oxSWEMEkszrxXEA', # N-O-D-E
    'UC2eYFnH61tmytImy1mTYvhA', # Luke Smith
    'UCpnkp_D4FLPCiXOmDhoAeYA', # Unusual Videous
    'UCxt9Pvye-9x_AIcb1UtmF1Q', # ashens
    ''
]

subreddits = [
    'unixporn'
]

def pretty_print(j):
    print(json.dumps(j, indent=4))

def exception_handler(request, exception):
    print("Request failed", exception)

for i in youtube_channel_ids:
    urls.append('http://www.youtube.com/feeds/videos.xml?channel_id=' + i)

#for i in subreddits:
    #urls.append('https://old.reddit.com/r/' + i + '.rss')

headers = {
    'User-Agent': 'aikrtionrstdirpdrrstd'
}

requests = (grequests.get(u, headers=headers, stream=True) for u in urls)
responces = (grequests.map(requests, exception_handler=exception_handler))

for r in responces:
    # can check url to determine what to extract
    #print(r.url)
    if r.status_code != 200:
        continue
    f = feedparser.parse(r.text)

    # youtube parse
    for entry in f['entries']:

        published = entry['published']
        published = published.split('+', 1)[0]
        published = datetime.strptime(published, "%Y-%m-%dT%H:%M:%S").timestamp()

        rss.append({
            'type': 'youtube',
            'author': f['feed']['title'],
            'title': entry['title'].replace('/', '|').replace("\'", "").replace("\"", ""),
            'summary': entry['summary'],
            'published': published,
            'link': entry['link'],
            'thumbnail': entry['media_thumbnail'][0]['url']
        })

#pretty_print(rss)

s=" "

rss=sorted(rss, key=lambda i: i["published"])

urls={}

for i in rss:
    time.sleep(0.0001) # enough to allow sorting by date
    with open("out/" + i["author"] + " - " + i["title"], 'w') as o:
        o.write(i["title"])
        o.write("\n")
        o.write(i["author"])
        o.write("\n")
        o.write(str(datetime.fromtimestamp(i["published"])))
        o.write("\n")
        o.write("----------------------------")
        o.write("\n")
        o.write(i["summary"])
        o.write("\n")
        o.write(i["link"])
        urls[i["thumbnail"]] = i["author"] + " - " + i["title"]

requests = (grequests.get(u, headers=headers, stream=True) for u in urls.keys())
responces = (grequests.map(requests, exception_handler=exception_handler))

for r in responces:
    if r.status_code != 200:
        continue
    with open("yttmb/" + urls[r.url] + ".jpg", 'wb') as f:
        f.write(r.content)
