#!/bin/bash

get_first_number() {
  echo "$1" | sed 's@^[^0-9]*\([0-9]\+\).*@\1@'
}

while read l; do
  [[ ! "$l" == *"color"* ]] && [[ ! "$l" == *"ground"* ]] && continue
  new_line="#define "
  if [[ "$l" =~ "foreground" ]]; then
    new_line+="FOREGROUND "
  elif [[ "$l" =~ "background" ]]; then
    new_line+="BACKGROUND "
  else
    index=$(get_first_number "$l")
    new_line+="COLOR$index "
  fi

  color=$(echo "$l" | awk '{ print $2 }')
  new_line+="$color"
  echo "$new_line"
done <<< "$(cat $1)"
