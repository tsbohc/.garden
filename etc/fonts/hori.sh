setup() {
  link fonts.conf ~/.config/fontconfig/fonts.conf
}

remove() {
  unlink ~/.config/fontconfig/fonts.conf
}
