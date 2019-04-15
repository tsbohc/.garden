#!/bin/bash

set_vim_theme() {
  # set vim colorscheme in vimrc
  if grep -q "^colorscheme" ~/blueberry/vimrc; then
    sed -i s/"^colorscheme.*"/"colorscheme $1"/ ~/blueberry/vimrc
  fi
}

get_color() {
    color=$(awk '/^\*'$2':(.*)/ { print substr($2,2) }' < ~/blueberry/xres/$1)
    echo $color
}

# have a main .Xresources with general settings, and a separate for colors through source
# change the sourcing and get the colors from the file to which the sourcing was changed

set_st_colors() {
  for i in {0..15}; do
    sed -i '/\/\* _color'$i'_ \*\// { n; s/.*/'"  \"\#"$(get_color $1 "color"$i)"\","'/ }' ~/blueberry/sl/st/config.h
  done

  sed -i '/\/\* _colorfg_ \*\// { n; s/.*/'"  \"\#"$(get_color $1 "foreground")"\","'/ }' ~/blueberry/sl/st/config.h
  sed -i '/\/\* _colorbg_ \*\// { n; s/.*/'"  \"\#"$(get_color $1 "background")"\","'/ }' ~/blueberry/sl/st/config.h

  cd ~/blueberry/sl/st
  sudo make install
}

main() {
  set_vim_theme $1
  set_st_colors $1
}

main $1
