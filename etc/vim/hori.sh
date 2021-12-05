setup() {
  link vimrc ~/.vimrc
  link vimrc ~/nvim/init.vim
}

remove() {
  unlink ~/.vimrc
  unlink ~/nvim/init.vim
}
