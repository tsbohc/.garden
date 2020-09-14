#!/bin/bash

path="~/todo"

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


echo "$left|$right"
