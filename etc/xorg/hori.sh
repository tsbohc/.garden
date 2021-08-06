setup() {
  link $(render xinitrc) "~/.xinitrc"
  link xresources "~/.Xresources"
}


remove() {
  unlink "~/.xinitrc"
  unlink "~/.Xresources"
}
