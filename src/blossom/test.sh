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

declare -a _VARSETS
declare -a _MODULES
declare -A DESTINATIONS
declare -A _LIBRARY

# {{{ varset
varset() {
  # so, basically this creates an assoc array with by splitting values past first
  # into k,v pairs. thus the name of the array is the first passed parameter
  n="$#"
  (( $n < 2 )) && echo 'varset expected k v pairs' && return
  [[ $(( n%2 )) == 0 ]] && echo 'varset expected even number of k and v' && return
  declare -n ref="$1" 
  declare -gA "$1"
  shift
  params=( "$@" ) # create an array from arguments
  for ((i=0; i<$#; i=i+2)) ; do
    ref["${params[$i]}"]="${params[$((i+1))]}"
  done
  _VARSETS+=( "${!ref}" ) # add name of the array to varsets
}
# }}}

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

yay-() {
  echo "yay $@"
}

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
  # need to check if _CURRENT_VARSETS are in _VARSETS

  # TODO: move somewhere else
  [ -d "$_COMPILE_TARGET" ] || mkdir -p "$_COMPILE_TARGET"

  if [ ! "${_LIBRARY[$1]+woo}" ] ; then
    echo "$1 not found!"
    return
  fi

  fn_fr="$1"
  path_to="$2"
  [[ "${path_to:0:1}" == '^' ]] && path_to="$HOME/.config${path_to:1}"

  shift # takes a number?
  shift
  _CURRENT_VARSETS=( "$@" )

  if install? ; then

    cp "${_LIBRARY[$fn_fr]}" "$_COMPILE_TARGET/$fn_fr"

    for varset in "${_CURRENT_VARSETS[@]}" ; do
      declare -n varset_ref="$varset"
      for k in "${!varset_ref[@]}" ; do
        fr="{@:-$k-:@}"
        to="${varset_ref[$k]}"
        sed -i -e "s/${fr}/${to}/g" "$_COMPILE_TARGET/$fn_fr"
      done
    done

    ln -sfn "$_COMPILE_TARGET/$fn_fr" "$path_to"

  else
    echo "remove ln $1"
  fi
}

# config code
# --------------

_COMPILE_TARGET="$HOME/.config/blossom" # no end slash!! shouldn't really be an option
_CONFIG_SOURCE="$HOME/.garden/etc" # no end slash!!

varset kohi \
  foreground 'E2E0DF' background '2b2b2c' \
  color0     '2b2b2c' color8     '616161' \
  color1     'E78485' color9     'E78485' \
  color2     '93BE93' color10    '93BE93' \
  color3     'ECC679' color11    'ECC679' \
  color4     '8CB7CA' color12    '8CB7CA' \
  color5     'D4A1BD' color13    'D4A1BD' \
  color6     '87C0B0' color14    '87C0B0' \
  color7     'B4B3B1' color15    'E2E0DF'

colorscheme="kohi"

@alacritty() {
  yay- alacritty
  .. alacritty ^/alacritty/alacritty.yml $colorscheme
}

@bspwm() {
  yay- bspwm sxhkd
  .. bspwmrc ^/bspwm/bspwmrc $colorscheme
  .. sxhkdrc ^/sxhkd/sxhkdrc
}

@xorg() {
  #.. xinitrc ~/.xinitrc
  .. xresources ~/.Xresources $colorscheme
}

@picom() {
  yay- picom
  .. picom ^/picom.conf
}

@polybar() {
  .. polybar ^/polybar/config
}

@zathura() {
  yay- zathura zathura-pdf-mupdf zathura-djvu
  .. zathurarc $colorscheme
}

@latex() {
  echo
}


# init
# --------------

# process options
action="$1" ; shift

case $action in
  -i|-install) action="i" ;;
  -r|-remove) action="r" ;;
  *) exit ;;
esac

# parse the config tree into an assoc array of filename:filepath
while read -r path ; do
  filename="${path##*/}"
  if [ ${_LIBRARY["$filename"]+woo} ] ; then
    echo "more than one $filename in config path!"
    exit
  fi
  _LIBRARY["$filename"]="$path"
done < <(find "$_CONFIG_SOURCE" -type f)

# process modules given in the parameters
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
