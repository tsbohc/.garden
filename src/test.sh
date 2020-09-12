#!/bin/bash

_bspc() {
  #bspc subscribe all | while read -r e; do
  #  echo "$e"
  #done

  for i in {1..5}; do
    echo "$i event"
    sleep 1
  done
  return
}

_bspc &

wait
echo "done"
exit 0
