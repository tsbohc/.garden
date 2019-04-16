#!/bin/bash

# add check for file existence, like config.h

set_vim_theme() {
  # set vim colorscheme in vimrc
  if grep -q "^colorscheme" ~/blueberry/vim/colsh.vim; then
    sed -i s/"^colorscheme.*"/"colorscheme $1"/ ~/blueberry/vim/colsh.vim
  fi
}

get_color() {
  # query colors from xrdb
  color=$(xrdb -query | awk '/^\*'$1':(.*)/ { print $2 }')
  echo $color
}

set_st_color() {
  # edit st's config.h
  sed -i '/\/\* _'$1'_ \*\// { n; s/.*/'"  \""$(get_color $1)"\","'/ }' ~/blueberry/sl/st/config.h
}

set_statusline_color() {
  if [[ $2 == "bg" ]]; then
    sed -i '/\" _'$1$2'_/ { n; s/.*/'"hi stl"$1$2" gui"$2"=""$(get_color $1)"" guifg="$(get_color "background")" gui=bold"'/ }' ~/blueberry/vim/colsh.vim
  else
    sed -i '/\" _'$1$2'_/ { n; s/.*/'"hi stl"$1$2" gui"$2"=""$(get_color $1)"" guibg="$(get_color "color8")""'/ }' ~/blueberry/vim/colsh.vim
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

  cd ~/blueberry/sl/st
  sudo make install

  # set vim theme
  set_vim_theme $1

  # set vim statusline colors
  for i in {9..12}; do
    set_statusline_color "color"$i "bg"
  done
  for i in {9..12}; do
    set_statusline_color "color"$i "fg"
  done

  sed -i '/\" _User1_/ { n; s/.*/'"hi User1 guibg="$(get_color "color4")" guifg="$(get_color "background")""'/ }' ~/blueberry/vim/colsh.vim
  sed -i '/\" _User2_/ { n; s/.*/'"hi User2 guibg="$(get_color "color8")" guifg="$(get_color "color4")""'/ }' ~/blueberry/vim/colsh.vim
  sed -i '/\" _User3_/ { n; s/.*/'"hi User3 guibg="$(get_color "color8")" guifg="$(get_color "foreground")""'/ }' ~/blueberry/vim/colsh.vim
  sed -i '/\" _User4_/ { n; s/.*/'"hi User4 guibg="$(get_color "background")" guifg="$(get_color "color8")""'/ }' ~/blueberry/vim/colsh.vim
  sed -i '/\" _User5_/ { n; s/.*/'"hi User5 guibg="$(get_color "color8")" guifg="$(get_color "foreground")""'/ }' ~/blueberry/vim/colsh.vim
  sed -i '/\" _User6_/ { n; s/.*/'"hi User6 guibg="$(get_color "foreground")" guifg="$(get_color "background")""'/ }' ~/blueberry/vim/colsh.vim
}


main $1
