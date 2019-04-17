#!/bin/bash

# add check for file existence, like config.h

red="\x1b[31m"
green="\x1b[32m"
yellow="\x1b[33m"
blue="\x1b[34m"
gray="\x1b[90m"
escape="\x1b[0m"
log() { echo -ne "["$2$1$escape"] "$3"                                   \r"; }

if [[ $# == 0 ]]; then
  log "!" $red "no colorscheme provided"
  exit 1
elif [[ $# > 1 ]]; then
  log "!" $red "wrong number of arguments"
  exit 1
else
  if [[ ! -f ~/blueberry/xres/$1 ]]; then
    log "!" $red "~/blueberry/xres/$1 does not exist"
    exit 1
  fi
fi

# fallback colors
if xrdb -query | grep -q "^\*color237"; then
  _gray="color237"
else
  _gray="color8"
fi

set_vim_theme() {
  # set vim colorscheme in vimrc
  log ">" $green "colorscheme $1"
  sed -i s/"^colorscheme.*"/"colorscheme $1"/ ~/blueberry/vim/colman.vim
}

get_color() {
  # query colors from xrdb
  color=$(xrdb -query | awk '/^\*'$1':(.*)/ { print $2 }')
  echo $color
}

set_st_color() {
  # edit st's config.h
  color_value=$(get_color $1)
  log ">" $green "$1 > $color_value"
  sed -i '/\/\* _'$1'_ \*\// { n; s/.*/'"  \""$color_value"\","'/ }' ~/blueberry/sl/st/config.h
}

set_statusline_color() {
  log ">" $green "$1$2"
  if [[ $2 == "bg" ]]; then
    sed -i '/\" _'$1$2'_/ { n; s/.*/'"hi stl"$1$2" gui"$2"=""$(get_color $1)"" guifg="$(get_color "background")" gui=bold"'/ }' ~/blueberry/vim/colman.vim
  else
    sed -i '/\" _'$1$2'_/ { n; s/.*/'"hi stl"$1$2" gui"$2"=""$(get_color $1)"" guibg="$(get_color $_gray)""'/ }' ~/blueberry/vim/colman.vim
  fi
}

main() {
  # add color values to the main .Xresources file
  xrdb -merge "$HOME/blueberry/xres/$1"

  # edit the st source and recompile
  for i in {0..15}; do
    set_st_color "color"$i
  done
  set_st_color "foreground"
  set_st_color "background"

  # set vim theme
  set_vim_theme $1

  # set vim statusline colors
  for i in {9..12}; do
    set_statusline_color "color"$i "bg"
  done
  for i in {9..12}; do
    set_statusline_color "color"$i "fg"
  done

  log ">" $green "User1"
  sed -i '/\" _User1_/ { n; s/.*/'"hi User1 guibg="$(get_color "color4")" guifg="$(get_color "background")""'/ }' ~/blueberry/vim/colman.vim
  log ">" $green "User2"
  sed -i '/\" _User2_/ { n; s/.*/'"hi User2 guibg="$(get_color $_gray)" guifg="$(get_color "color4")""'/ }' ~/blueberry/vim/colman.vim
  # filename
  log ">" $green "User3"
  sed -i '/\" _User3_/ { n; s/.*/'"hi User3 guibg="$(get_color $_gray)" guifg="$(get_color "foreground")""'/ }' ~/blueberry/vim/colman.vim
  log ">" $green "User4"
  sed -i '/\" _User4_/ { n; s/.*/'"hi User4 guibg="$(get_color "background")" guifg="$(get_color "color237")""'/ }' ~/blueberry/vim/colman.vim
  log ">" $green "User5"
  sed -i '/\" _User5_/ { n; s/.*/'"hi User5 guibg="$(get_color $_gray)" guifg="$(get_color "foreground")""'/ }' ~/blueberry/vim/colman.vim
  log ">" $green "User6"
  sed -i '/\" _User6_/ { n; s/.*/'"hi User6 guibg="$(get_color "foreground")" guifg="$(get_color "background")""'/ }' ~/blueberry/vim/colman.vim
  echo -e "["$green">"$escape"] done                                    "

  cd ~/blueberry/sl/st
  sudo make install
}


main $1
