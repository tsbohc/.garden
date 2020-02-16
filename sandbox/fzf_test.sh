#!/bin/bash

data=$(cat data.txt)

delimiter="@@@"

choice=$(echo "$data" | fzf --no-sort --with-nth='2' -d "$delimiter")

if [[ "$choice" != "" ]]; then
  index=$(awk -F"$delimiter" '{print $1}' <<< "$choice")
  value=$(awk -F"$delimiter" '{print $2}' <<< "$choice")
  # increment index
  index=$((index+1))
  # write new index
  data=$(sed "s/$choice/$index$delimiter$value/g" <<< "$data")
  # sort and remove duplicates
  data=$(echo "$data" | sort -k1,1nr | awk -F"$delimiter" '!x[$2]++')
  # write back to the file
  echo "$data" > data.txt
fi

cat data.txt
