#!/bin/bash

# name: blossom!

  # parse normal array as assoc (needs an even number check)
  #for ((i=1; i<="$#"; i=i+2)) ; do
  #  v=$((i+1))
  #  echo "${!i} : ${!v}"
  #done

# extensible: binary is source code
# programmable: config is source code
# portable: one file with no dependencies
# pleasant: no defining assoc arrays by hand, no quoting hell
# pretty: logging has to be nice to look at

# templating: push values into templates before linking
# deal with orphans: clean up in the background
# tell not do: dry mode option

# logging mockup
# how do i show commands inside a function?

# declare -f? seems like a lot of work though... maybe?
# - get the excerpt with function
# - strip first and last lines
# - print as module body?

# --verbose

# + bspwm < everforest
#    yay -S bspwm sxhkd
#    . bspwmrc ~/.config/bspwm/bspwmrc
#    . sxhkdrc ~/.config/sxhkd/sxhkdrc
#
# - zathura

# normal

# + bspwm < everforest
# - zathura


function inspect {
  # print associative array k, v pairs
  local -n ref=$1
  echo
  echo "inspect: $1"
  for k in "${!ref[@]}" ; do
    echo "$k : ${ref[$k]}"
  done
}

# {{{
## eval is like... magic. fuck the evileval, I want to do some stupid shit
## i want to see how far i can push it
## https://stackoverflow.com/questions/44379252/dynamic-variable-names-for-an-array-in-bash
## fuck associative arrays, better use a normal one with some delimiter
#
## binary is source code
## has to be portable (bash) and 1 file
#
## notes:
## declare -A $name - failed because assigning a key throws an error, same with eval
#
#
#current_module=""
#
#module() {
#  (( "$#" == 0 )) && return
#  name="$1" ; shift
#  #declare -g ${name}
#  #$name+=("w")
#  current_module="$name"
#  #bars+=("$name")
#}
#
#link() {
#  echo "$1 -> $2"
#}
#
#.() {
#  # store instructions with function name
#  # this essentially makes them commands
#  # it'll preserve order this way, with other .-like funcs
#  eval "$current_module+=('link $1 $2')"
#  #eval "$(printf %s+=%q "$current_module"
#}
#
#
#module test
##~ yay -Syu bspwm sxhkd # ~ stores the input as a command
#. bspwmrc ~/.config/bspwm/bspwmrc
#. sxhkdrc ~/.config/sxhkd/sxhkdrc
#
#inspect test
#
## simply loop through modules (stored in bars in soap) and evaluate instructions
##eval '${'$current_module'['0']}'
#
#
#
# }}}

.() {
  # compile file and link "compiled/$1 -> $2"
  # need to check if _CURRENT_VARSETS are in _VARSETS

  # maybe i should create a dictionary file (multiline string) and give it to awk?
  # or just run sed many times?

  echo
  echo "$1 -> $2"
  for varset in "${_CURRENT_VARSETS[@]}" ; do
    declare -n varset_ref="$varset"
    for ((i=0; i<${#varset_ref[@]}; i=i+2)) ; do
      v=$((i+1))
      echo "{@:-${varset_ref[$i]}-:@}   ->   ${varset_ref[$v]}"
    done
  done
}

declare -a _VARSETS
declare -a _MODULES

declare -a _CURRENT_VARSETS

# ------------
# varset
# ------------

varset() {
  n="$#"
  (( $n < 2 )) && echo "varset expected k v pairs" && return
  [[ $((n%2)) == 0 ]] && echo "varset expected even number of k and v" && return

  declare -n ref="$1" ; shift
  # create an array from arguments
  ref=( "$@" )
  # add name of the array to varsets
  _VARSETS+=("${!ref}")

}

# this is better
varset everforest \
  background "292c3e" \
  foreground "ebebeb"

varset varset_test \
  foo bar

# use variables to reference varsets!
colorscheme="everforest"

#inspect $colorscheme

inject() {
  # set a global to pass info to link function
  _CURRENT_VARSETS=( "$@" )
}

mod:module_test() {
  inject $colorscheme varset_test
  #echo "hook-before"
  . bspwmrc ~/.config/bspwm/bspwmrc
  . sxhkdrc ~/.config/sxhkd/sxhkdrc
  #echo "hook-after"
}

# get all function definitions
#declare -f

# get a function name
#ref="mod.test"

# execute it by reference
#$ref




# cli mockup

# loop through args and install each module
#soap -i bspwm test

# remove modules
# soap -r test

# sync module (install active, remove inactive)
# soap -s bspwm


get-modules() {
  while read -r line ; do
    if [[ "$line" == "declare -f mod:"* ]] ; then
      # could be a bad idea?
      mod_name="${line:15}"
      _MODULES+=( "$mod_name" )
    fi
  done < <(declare -F)
}

get-modules

#inspect _MODULES
#inspect _VARSETS



mod:module_test











#this works but somewhat limited (names) and funky syntactically
#declare -A injtest=(
#  [background]=292c3e
#  [foreground]=ebebeb
#)
#
#inspect injtest
