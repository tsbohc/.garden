import io
import os
from bs4 import BeautifulSoup

#name = "1.html"
path = "source/"

with open ("output", "w", encoding="utf-8") as output:
    for name in os.listdir(path):
        with open (path + name, encoding="utf-8") as f:
            soup = BeautifulSoup(f, features="html5lib")
            p_tags = soup.find_all('p')
            for p in p_tags:
                result = ' '.join(p.text.split())
                for line in io.StringIO(result):
                    output.write(line + "\n")

