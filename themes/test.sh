#!/bin/bash

#sed -i '/! theme/!b;n;c#include \"/home/sean/blueberry/themes/{}\"' ~/.Xresources
#xrdb ~/.Xresources

show_colour() {
  perl -e 'foreach $a(@ARGV){print "\e[48;2;".join(";",unpack("C*",pack("H*",$a)))."m \e[49m"}' "$@"
}

preview() {
  echo
  while read l; do
    [[ $l != *"define"* ]] && continue
    index=$(echo $l | awk '{ print $2 }')
    color=$(echo $l | awk '{ print substr($3,2) }')
    if [[ "$index" =~ "COLOR" ]]; then
      show_colour $color
      show_colour $color
      echo -n " "
    fi
  done <<< "$(cat /home/sean/blueberry/themes/$1)"
  echo "$1"
}

main() {
  choice=$(ls | fzf --height=10 --bind=esc:abort)
  if [[ "$choice" != "" ]]; then
    preview $choice
    set_term_colors "$choice"
    echo
    main
  fi
}

set_term_colors() {
  [[ ! -f "/home/sean/blueberry/themes/${1}" ]] && echo "boo" && exit 1
  sed -i "/! theme/!b;n;c#include \"/home/sean/blueberry/themes/${1}\"" ~/.Xresources
  sed -i "/\" theme/!b;n;ccolorscheme ${1}" /home/sean/blueberry/vimrc
  xrdb ~/.Xresources
  update_colors
}

update_colors() {
  # check out SeungheonOh/xrdm!
  sequence=""
  while read l; do
    [[ $l != *"*."* ]] && continue
    lineseg=( $l )
    index=$(echo $l | sed -e "s/\s.*//" -e "s/^*.//" -e "s/color//" -e "s/:$//")
    color=$(echo $l | sed -e "s/.*\s//")
    # Note
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
}

#python3 ~/blueberry/sc/tinyfetch.py
#preview

main

