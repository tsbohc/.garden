depend() {
  install zsh
}

setup() {
  link zshenv ~/.zshenv
  link zshrc ~/.config/zsh/.zshrc
}

remove() {
  unlink ~/.zshenv
  unlink ~/.config/zsh/.zshrc
}
