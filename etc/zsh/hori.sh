depend() {
  install zsh lua fzf
}

setup() {
  link zshenv ~/.zshenv
  link zshrc ~/.config/zsh/.zshrc

  # TODO ask function in hh with [y/n] etc
  local p; p="$(which zsh)"
  if ! [[ $SHELL == "$p" ]]; then
    echo "hh: $p"
    chsh -s "$p"
  fi
}

remove() {
  unlink ~/.zshenv
  unlink ~/.config/zsh/.zshrc
}
