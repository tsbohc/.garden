add() {
  link vimrc ~/.vimrc
  ln -s ~/.vimrc /root/.vimrc
}

del() {
  unlink ~/.vimrc
  unlink ~/nvim/init.vim
}
