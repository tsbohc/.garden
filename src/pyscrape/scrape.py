import re
import os
import grequests
import requests
from random import randint
from time import sleep
from bs4 import BeautifulSoup
import pprint
pp = pprint.pprint

urls = [
        "https://readmanga.live/list?sortType=DATE_UPDATE"
        ]

for i in range(1, 306):
    urls.append("https://readmanga.live/list?sortType=DATE_UPDATE&offset=" + str(i * 70))

def chunks(a, n):
    for i in range(0, len(a), n):
        yield a[i:i + n]

def strip(s):
    return re.sub('[^a-zA-Z0-9]', '_', s)

def scrape(urls):
    # remove urls that've already been cached
    for url in list(urls):
        if os.path.isfile("data/" + strip(url)):
            print("got: " + url)
            urls.remove(url)

    # nothing to do
    if len(urls) == 0:
        return

    failed_urls = []

    # send out requests in batches
    for chunk in chunks(urls, 16):
        print("sleeping")
        sleep(randint(2, 10))
        print("sending out " + str(len(chunk)) + " requests")
        requests = (grequests.get(u) for u in chunk)
        responces = grequests.map(requests)

        for r in responces:
            if r.status_code != 200:
                print("failed:" + r.url)
                failed_urls.append(r.url)
            else:
                path = "data/" + strip(r.url)
                print("get: " + r.url)
                with open(path, 'w') as f:
                    f.write(r.text)

    if len(failed_urls) > 0:
        print("sleeping before retrying")
        time.sleep(10)
        scrape(failed_urls)

scrape(urls)
