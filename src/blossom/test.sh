#!/bin/bash

foo(){
  echo "$@"
}

#foo ( a \
#b c d )

a=(
  foo 10
  bar 9
)

foo "${a[@]}"
