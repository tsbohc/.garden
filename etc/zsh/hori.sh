depend() {
  install zsh lua fzf
}

add() {
  link zshenv ~/.zshenv
  link zshrc ~/.config/zsh/.zshrc
  link zlogin ~/.config/zsh/.zlogin

  # TODO ask function in hh with [y/n] etc
  local p; p="$(which zsh)"
  if ! [[ $SHELL == "$p" ]]; then
    echo "hh: $p"
    chsh -s "$p"
  fi
}

del() {
  unlink ~/.zshenv
  unlink ~/.config/zsh/.zshrc
}
