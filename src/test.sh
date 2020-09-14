#!/bin/bash


declare -A _c_actions=(
  [x]=_$1_terminal
)

_w_terminal() { echo "w term" ; }
_c_terminal() { echo "c term" ; }

${_c_actions[x]}
