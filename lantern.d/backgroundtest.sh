#!/bin/bash

# proof of concept of processing data after fzf launch
# and reloading it when done

prepare_data() {
  de() {
    count=0
    while read -r line; do
      echo "$count | $line"
      ((count++))
    done <<< "$db"
  }
  sleep 1s
  echo "$(de)" > /tmp/new_data
  xdotool key ctrl+r
}

db=$(cat ~/blueberry/sandbox/data)

prepare_data &
pid=$!

echo "$db" | fzf --bind "ctrl-r:reload(cat /tmp/new_data)"
