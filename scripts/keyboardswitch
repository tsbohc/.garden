#!/bin/bash

if [ $(setxkbmap -print | awk -F'+' '/xkb_symbols/ {print $2}') != 'us' ]; then
  setxkbmap us
else
  setxkbmap ru
fi
