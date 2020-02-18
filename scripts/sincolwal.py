#!/usr/bin/env python3

from PIL import Image
import sys
import subprocess

img = Image.new('RGB', (2,2), color='#'+sys.argv[1])
img.save('sincolwal.png')

subprocess.run('feh --bg-fill ~/blueberry/sc/sincolwal.png', shell=True)
