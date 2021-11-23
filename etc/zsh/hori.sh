depend() {
  install zsh
}

setup() {
  link zshrc "~/.zshrc"
}

remove() {
  unlink "~/.zshrc"
}
