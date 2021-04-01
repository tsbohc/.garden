#!/bin/bash

# blossom -i module1 module2 ... -- install
# blossom -r module1 module2 ... -- remove
# blossom -i                     -- install interactively
# blossom -r                     -- remove interactively

# {{{ inspect
inspect() {
  # print associative array k, v pairs
  local -n ref=$1
  echo
  echo "inspect: $1"
  for k in "${!ref[@]}" ; do
    echo "$k : ${ref[$k]}"
  done
}
# }}}

declare -a _MODULES
declare -A LIBRARY

# {{{ install/remove
action=""
i() {
  action="i"
  "$@"

}

r() {
  action="r"
  "$@"
}
# }}}

# should get-installed and get-removed and add + or - befor module name
# {{{ list-modules
list-modules() {
  _MODULES=()
  while read -r line ; do
    if [[ "$line" == "declare -f @"* ]] ; then
      # could be a bad idea?
      mod_name="${line/"declare -f @"/""}"
      _MODULES+=("$mod_name")
    fi
  done < <(declare -F)
  printf "%s\n" "${_MODULES[@]}"
}
# }}}

install?() {
  if [[ "$action" == "i" ]] ; then
    return 0
  else
    return 1
  fi
}

..() {
  if install? ; then
    echo "ln -s $1"
  else
    echo "remove ln $1"
  fi
}

# config code
# --------------

# spaces are not accounted for, because who has spaces in their config paths?
LIBRARY=(
  ["alacritty"]="alacritty.yml ~/.config/alacritty/alacritty.yml"
  ["bspwm"]="bspwmrc ~/.config/bspwm/bspwmrc"
  ["sxhkd"]="sxhkdrc ~/.config/sxhkd/sxhkdrc"
)

colorscheme="my_colors"

@alacritty() {
  #yay- alacritty
  .. alacritty [$colorscheme]
}

@bspwm() {
  yay- bspwm sxhkd
  .. bspwm [$colorscheme]
  .. sxhkd
}


# init
# --------------

action="$1" ; shift

case $action in
  -i|-install) action="i" ;;
  -r|-remove) action="r" ;;
  *) exit ;;
esac

if [[ "$#" > 0 ]] ; then
  for m in "$@" ; do
    "@"$m
  done
else
  selection="$(list-modules | fzf -m --bind 'tab:toggle+clear-query')"
  if [[ "${#selection}" > 0 ]] ; then
    while read -r m ; do
      "@"$m
    done <<< "$selection"
  else
    echo "nothing to do"
  fi
fi
