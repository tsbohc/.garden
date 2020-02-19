#!/bin/bash

#if [[ -d "$1" ]]; then
#  echo d
#elif [[ -x "$1" ]]; then
#  echo x
#else
#  echo else
#fi
#
#file "$1"


[[ "$(file "$1")" == *"PDF"* ]] && echo yes
