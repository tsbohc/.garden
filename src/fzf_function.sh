#!/bin/bash

list="one
two
three"

fzf_cmd() {
  echo "{}"
}

fzf_cmd2="
  echo woo
  echo {}"

fzf_cmd_wrapper="type fzf_cmd | awk 'NR > 4 { print last } { last=$0 }'"

echo "$list" | fzf --bind "change:execute[$fzf_cmd2]"

