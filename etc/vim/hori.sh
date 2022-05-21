add() {
  link vimrc ~/.vimrc
  link vimrc ~/nvim/init.vim
  ln -s ~/.vimrc /root/.vimrc
}

del() {
  unlink ~/.vimrc
  unlink ~/nvim/init.vim
}
