#!/bin/sh

depend() {
  install zsh lua fzf
}

add() {
  link zshenv ~/.zshenv
  link zshrc ~/.config/zsh/.zshrc
  link zlogin ~/.config/zsh/.zlogin

  # TODO ask function in hori with [y/n] etc
  p="$(which zsh)"
  if ! [ "$SHELL" = "$p" ]; then
    echo "found zsh at '$p'"
    chsh -s "$p"
  fi
}

del() {
  unlink ~/.zshenv
  unlink ~/.config/zsh/.zshrc
}
