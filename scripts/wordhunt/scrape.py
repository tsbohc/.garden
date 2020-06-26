import time
import requests
from bs4 import BeautifulSoup

line = "дз"
index = 0

URL = "https://wooordhunt.ru/dic/list/ru_en/"



with open("page_list", "r") as page_list:
    for index, line in enumerate(page_list):
        line = line.strip()

        page = requests.get(URL + line)
        soup = BeautifulSoup(page.content, 'html.parser')
        result = soup.find('div', { 'id': 'content' })

        if page.status_code == 200:
            with open("source/" + str(index+1) + ".html", "w") as file:
                print(str(index+1) + " " + line)
                file.write(result.prettify())
        else:
            print("ERROR ON PAGE:")
            print(str(index+1) + " " + line)
            break

        time.sleep(0.1)
