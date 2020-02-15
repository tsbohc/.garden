#!/bin/bash

out="default"
tes="default"

preview="echo {} > test.log"
execute="cat test.log"

#--bind "change:execute(echo {})"

out=$(ls | fzf --print-query --bind "change:execute($preview)" --preview "$execute");

cat "test.log"
