import re
import os
from bs4 import BeautifulSoup

path = "source/"

count = 0
total = 32459

with open ("output", "w", encoding="utf-8") as output:
    for name in os.listdir(path):
#name = "24167.html"

        with open (path + name, encoding="utf-8") as f:
            count += 1
            soup = BeautifulSoup(f, features="html5lib")

            if bool(soup.find('div', { 'class': 'wd_error' })) or bool(soup.find('a')) == False:
                #print("WWWWWWWWWWARN")
                continue

            russian_word = soup.find('h1').find_all(text=True, recursive=False)[0].strip().lower()

            main_div = soup.find('div', { 'id': 'wd_content' })
            items = main_div.find_all(['a', 'h4'])
            out = russian_word + ": "
            for item in items:
                if item.name == "a":
                    if bool(re.search('[a-zA-Z]', item.text)):
                        out += item.text.strip() + ", "
                else:
                    break
            if len(out) > len(russian_word) + 3:
                out = out[:-2]
                print(str(int(count/total*100)) + " " + out)
        #            else:
        #                print("WWWWWWWWWWWWWWWWWWW\nWWWWWWWWWWWWWW")
                output.write(name[:-5] + "|" + out + "\n")
