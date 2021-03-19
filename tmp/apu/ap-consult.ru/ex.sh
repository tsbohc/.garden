#!/bin/bash

rm out
touch out

find ~/blueberry/tmp/apu/ap-consult.ru/ -type f -name "*.html" | while read line; do
  w3m -dump "$line" >> out
done


