#!/bin/bash

paths=("~" "~/a" "~/a/" "~/a/b" "~/a/b/" "~/a/b/c" "~/a/b/c/" "~/a/b/c/d" "~/a/b/c/d/")



for i in {1..1000}; do
  # 0.4
  #for path in "${paths[@]}"; do
  #  DIRNAME="$path"
  #  if [[ "$DIRNAME" =~ (.*)/([^/]+/+[^/]+)/*$ ]]; then
  #    #echo "$path: ${BASH_REMATCH[1]}:/${BASH_REMATCH[2]}"
  #    p="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
  #  elif [[ "$DIRNAME" =~ (.*)/([^/])/*$ ]]; then
  #    #echo "$path: ${BASH_REMATCH[1]}:/${BASH_REMATCH[2]}"
  #    p="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
  #  fi
  #done #| column -t -s ':'

  # 0.25
  for path in "${paths[@]}"; do
    length="${path//[!\/]}"
    length="${#length}"

    if (( "$length" > 1 )); then
      left="${path%/*}"
      right="/${left##*/}/${path##*/}"
      left="${left%/*}"
    else
      left="${path%/*}"
      right="/${path##*/}"
    fi
    p="$left$right"
  done

done
