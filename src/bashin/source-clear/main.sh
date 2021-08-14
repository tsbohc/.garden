#!/bin/bash

echo "$(basename "$0")"

hook() { # run hook 1 in package 2 once if defined
  P="$2"
  ( . "$P"
    echo "should run $1 in $P"
    if declare -F "$1" > /dev/null; then
      $1 ; unset "$1"
    fi )
}

hook 'h1' "p1.sh"
hook 'h2' "p2.sh"


hook 'yes' "p1.sh"
hook 'yes' "p2.sh"
