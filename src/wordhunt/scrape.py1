import random
import time
import requests
from bs4 import BeautifulSoup

# my adventure to break the internet and transcend my existence with an online dictionary

from_line = 25830
to_line = 32459

URL = "https://wooordhunt.ru/word/"

with open("ru-words.txt", "r") as input_file:
    for index, line in enumerate(input_file):

        if (index+1) < from_line:
            continue

        if (index+1) > to_line:
            break

        word = line.strip()
        page = requests.get(URL + word)
        soup = BeautifulSoup(page.content, 'html.parser')
        result = soup.find('div', { "id": "wd"})

        percentage = 100 * float(index+1)/float(to_line)
        bar_length = int(percentage/2.0)
        bar = ""
        for i in range(0, 50):
            if i == bar_length:
                bar += "┘"
            else:
                bar += "─"
        bar += ""

        if page.status_code == 200:
            with open("source/" + str(index+1) + ".html", "w") as file:
                print(bar + " " + str(int(percentage)) + " " + str(index+1) + " " + word)
                file.write(result.prettify())
        else:
            time.sleep(120)
            page = requests.get(URL + word)
            soup = BeautifulSoup(page.content, 'html.parser')
            result = soup.find('div', { "id": "wd"})

            if page.status_code == 200:
                with open("source/" + str(index+1) + ".html", "w") as file:
                    print(str(index+1) + " " + word)
                    file.write(result.prettify())
            else:
                with open("log", "w") as log:
                    log.write(str(index+1) + " " + word + " ERROR!!\n")
                break

        #time.sleep(random.uniform(0.1, 0.6))
        time.sleep(0.1)
