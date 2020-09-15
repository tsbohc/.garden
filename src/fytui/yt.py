import json
import xml.etree.ElementTree as ET
import urllib.request as URL
from datetime import datetime

rss = []
subscriptions_opml='subscriptions'

def fuck_namespace(el): # {{{
  '''Recursively search this element tree, removing namespaces.'''
  if el.tag.startswith("{"):
    el.tag = el.tag.split('}', 1)[1]
  for k in el.attrib.keys():
    if k.startswith("{"):
      k2 = k.split('}', 1)[1]
      el.attrib[k2] = el.attrib[k]
      del el.attrib[k]
  for child in el:
    fuck_namespace(child)
# }}}

def pretty_print(j):
    print(json.dumps(j, indent=4))

def get_rss_urls(filename):
    feeds = []

    tree = ET.parse(filename)
    for tag in tree.findall('.//outline'):
        url = tag.get('xmlUrl')
        if url:
            feeds.append(url)
    return feeds

feeds = get_rss_urls(subscriptions_opml)

i=len(feeds)

for feed in feeds:
    try:
        _f = URL.urlopen(feed)
    except URL.URLError as e:
        print(e.reason)
    else:
        with _f as f:
            tree = ET.fromstring(f.read().decode('utf-8'))
            fuck_namespace(tree)

            channel = tree.find('./title').text
            videos = tree.findall('./entry')

            for video in videos:
                title = video.find('./title').text
                url = video.find('./link').attrib['href']
                thumbnail = video.find('./group/thumbnail').attrib['url']

                published = video.find('./published').text
                published = published.split('+', 1)[0]

                published = str(datetime.strptime(published, "%Y-%m-%dT%H:%M:%S").timestamp())

                rss.append({
                    'channel'   : channel,
                    'title'     : title,
                    'url'       : url,
                    'published' : published,
                    'thumbnail' : thumbnail
                    })
            print(str(i) + " - " + channel)
            i=i-1

#pretty_print(rss)

output=""
d=' '

for video in rss:
    output+=video['channel'] + " -" + d + video['title'] + d + video['published'] + d + video['url'] + d + video['thumbnail'] + '\n'

output=output.rstrip() # strip newline

with open('cache', 'w') as f:
    f.write(output)
