#!/usr/bin/env python

import os
import random
import sys
import time
import math
from datetime import datetime
from PIL import Image

def welcome():
    print(""" 
    _  /_ _  _  _  /_ _  _ 
   /_ / //_//_//_ / //_//_/
           /           /   
               it chops things
""")

def crop(f, chop_size):
    img = Image.open(f)
    width, height = img.size

    print("[>] " + f)

    if chop_size > height:
        print("[!] height is less than chop size, skipping...")
        print("")
        img.close()
        return

    f_name = os.path.splitext(f)[0]
    f_extension = os.path.splitext(f)[1]
    os.mkdir(os.path.join(chop_dir, f_name))

    chop_count = int(math.ceil(height/chop_size))

    for i in range(chop_count):
        left = 0
        right = width
        top = i * chop_size

        if i != chop_count - 1:
            bottom = (i + 1) * chop_size
        else:
            bottom = height

        chop_name = f_name + "-" + str(i+1) + f_extension
        chop_path = os.path.join(chop_dir, f_name, chop_name)
        print(chop_path + ": " + str(top) + "-" + str(bottom))
        new_chop = img.crop((left, top, right, bottom))
        new_chop.save(chop_path)

    print("")
    img.close()
    return

welcome()

try:
    chop_size = int(input("[?] enter chop size: "))
except ValueError:
    print("[!] please enter a number")
    print("")
    sys.exit()

if chop_size < 0:
    print("[!] chop size is < 0")
    print("")
    sys.exit()

if chop_size < 100:
    answer = input("[!] are you sure? y/n ")
    print("")
    if answer != "y":
        sys.exit()

# create new dir for cropped files
chop_dir = "chop_" + datetime.now().strftime('%H-%M-%S') + "_" + str(random.randint(0, 1024))
os.mkdir(chop_dir)
print("--------------------------------------")

for entry in os.scandir('.'):
    if entry.is_file() and entry.name.lower().endswith(('.png', '.jpg', '.jpeg', '.tiff', '.bmp')):
        crop(entry.name, chop_size)

input("done! press enter to close")
