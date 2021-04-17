#!/usr/bin/zsh


prompt=""
while read -k 1 -s; do
  prompt="$REPLY"
  #loop
done

