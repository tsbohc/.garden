#!/bin/bash

# todo:
# varset from path (just variable value), 1 per line?

# goals
# extensible: binary is source code
# programmable: config is source code
# portable: one file with no dependencies
# pleasant: no defining assoc arrays by hand, no quoting hell
# pretty: logging has to be nice to look at

# templating: push values into templates before linking
# deal with orphans: clean up in the background
# tell not do: dry mode option

# notes:
# declare -A $name - failed because assigning a key throws an error, same with eval

# logging mockup:

# + bspwm < everforest
#    yay -S bspwm sxhkd
#    . bspwmrc ~/.config/bspwm/bspwmrc
#    . sxhkdrc ~/.config/sxhkd/sxhkdrc

inspect() {
  # print associative array k, v pairs
  local -n ref=$1
  echo
  echo "inspect: $1"
  for k in "${!ref[@]}" ; do
    echo "$k : ${ref[$k]}"
  done
}

declare -a _VARSETS
declare -a _MODULES
declare -a _CURRENT_VARSETS
declare -A _LIBRARY

_CONFIG_SOURCE="$HOME/.garden/etc"
_COMPILE_TARGET="$HOME/.config/blossom" # no end slash!!

refresh () {
  for word in "$@" ; do
    case "$word" in
      nvim)
        # TODO: needs a dependency check: pip3 install neovim-remote
        # {{{
        # signal all nvim instances to reload their configs via https://github.com/mhinz/neovim-remote
        for path in $(nvr --nostart --serverlist); do
          nvr -s --nostart --servername "$path" -cc 'source ~/.config/nvim/init.vim'
        done
        # }}}
        ;;
      bspwm)
        # {{{
        setxkbmap us
        bspc wm -r
        sleep 1 # shortcuts will be messed up unless we do this
        setxkbmap us -variant colemak
        # }}}
        ;;
      xres)
        # {{{
        # thanks: SeungheonOh/xrdm
        xrdb -merge ~/.Xresources
        sequence=""
        while read l; do
          [[ $l != *"*."* ]] && continue
          lineseg=( $l )
          index=$(echo $l | sed -e "s/\s.*//" -e "s/^*.//" -e "s/color//" -e "s/:$//")
          color=$(echo $l | sed -e "s/.*\s//")
          # St only has partial support of Xterm Control Sequence(Most X-based term have this),
          # instead it uses 256th color for BG, and 257th color for FG
          # or whatever it is set to in config.h
          if [ "$index" == "background" ]; then
            sequence+="\033]11;${color}\007" # Background
            sequence+="\033]17;${color}\007" # Background
            sequence+="\033]17;${color}\007" # Background
            sequence+="\033]708;${color}\007" # Border
            sequence+="\033]4;257;${color}\007" # Background for ST wiredo
          elif [ "$index" == "foreground" ]; then
            sequence+="\033]10;${color}\007" # Foreground
            sequence+="\033]19;${color}\007" # Foreground
            sequence+="\033]4;256;${color}\007" # Foreground for ST wiredo
          else
            sequence+="\033]4;${index};${color}\007" # Colors
          fi
        done <<< "$(xrdb -query)"
        for tty in /dev/pts/[0-9]*; do
          printf "%b" "$sequence" > "$tty"
        done
        # }}}
        ;;
    esac
  done
}

varset() {
  n="$#"
  (( $n < 2 )) && echo 'varset expected k v pairs' && return
  [[ $(( n%2 )) == 0 ]] && echo 'varset expected even number of k and v' && return
  declare -n ref="$1" ; shift
  ref=( "$@" ) # create an array from arguments
  _VARSETS+=( "${!ref}" ) # add name of the array to varsets
}

inject() {
  # set a global to pass info to link function
  echo "${FUNCNAME[1]} < $@"
  _CURRENT_VARSETS=( "$@" )
}

..() {
  # need to check if _CURRENT_VARSETS are in _VARSETS

  [ -d "$_COMPILE_TARGET" ] || mkdir -p "$_COMPILE_TARGET"

  if [ ! "${_LIBRARY[$1]+woo}" ] ; then
    echo "$1 not found!"
    return
  fi

  cp "${_LIBRARY[$1]}" "$_COMPILE_TARGET/$1"

  for varset in "${_CURRENT_VARSETS[@]}" ; do
    declare -n varset_ref="$varset"
    for ((i=0; i<${#varset_ref[@]}; i=i+2)) ; do
      fr="{@:-${varset_ref[$i]}-:@}"
      to="${varset_ref[$((i+1))]}"
      # this is pretty inefficient, but will do for now
      sed -i -e "s/${fr}/${to}/g" "$_COMPILE_TARGET/$1"
    done
  done

  ln -sfn "$_COMPILE_TARGET/$1" "$2"
}

varset gruvbox \
  colorscheme 'gruvbox' \
  foreground 'ebdbb2' background '32302f' \
  color0     '1d2021' color8     '928374' \
  color1     'cc241d' color9     'fb4934' \
  color2     '98971a' color10    'b8bb26' \
  color3     'd79921' color11    'fabd2f' \
  color4     '458588' color12    '83a598' \
  color5     'b16286' color13    'd3869b' \
  color6     '689d6a' color14    '8ec07c' \
  color7     'a89984' color15    'ebdbb2'

varset everforest \
  colorscheme 'everforest' \
  foreground 'd8caac' background '323d43' \
  color0     '868d80' color8     '868d80' \
  color1     'e68183' color9     'e68183' \
  color2     'a7c080' color10    'a7c080' \
  color3     'd9bb80' color11    'd9bb80' \
  color4     '89beba' color12    '89beba' \
  color5     'd3a0bc' color13    'd3a0bc' \
  color6     '87c095' color14    '87c095' \
  color7     'd8caac' color15    'd8caac'

varset colo \
  colorscheme 'colo' \
  foreground 'c6c2b9' background '322f30' \
  color0     'c6c2b9' color8     'c6c2b9' \
  color1     'c6c2b9' color9     'c6c2b9' \
  color2     'c6c2b9' color10    'c6c2b9' \
  color3     'c6c2b9' color11    'c6c2b9' \
  color4     'c6c2b9' color12    'c6c2b9' \
  color5     'c6c2b9' color13    'c6c2b9' \
  color6     'c6c2b9' color14    'c6c2b9' \
  color7     'c6c2b9' color15    'c6c2b9'

colorscheme='gruvbox'

mod:xres() {
  inject $colorscheme
  .. Xresources ~/.Xresources
  refresh xres
}

mod:nvim() {
  inject $colorscheme
  .. init.vim ~/.config/nvim/init.vim
  refresh nvim
}

mod:bspwm() {
  #setxkbmap us
  #bspc wm -r
  refresh bspwm
}

mod:alacritty() {
  inject $colorscheme
  .. alacritty.yml ~/.config/alacritty/alacritty.yml
}

#mod:alacritty() {
#  install alacritty
#  link alacritty $colorscheme
#
#}

#get-modules() {
#  while read -r line ; do
#    if [[ "$line" == "declare -f mod:"* ]] ; then
#      # could be a bad idea?
#      mod_name="${line:15}"
#      _MODULES+=( "$mod_name" )
#    fi
#  done < <(declare -F)
#}
#
#get-modules

while read -r path ; do
  filename="${path##*/}"
  #echo "$filename"
  [ ${_LIBRARY["$filename"]+woo} ] && echo "warning $filename"
  _LIBRARY["$filename"]="$path"
done < <(find "$_CONFIG_SOURCE" -type f)

#inspect _LIBRARY

#inspect _MODULES
#inspect _VARSETS

#mod:xres
#mod:nvim
#mod:bspwm
mod:alacritty

