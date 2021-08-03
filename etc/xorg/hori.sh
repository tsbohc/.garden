grow() {
  link $(render xinitrc) "~/.xinitrc"
  link xresources "~/.Xresources"
}


weed() {
  unlink "~/.xinitrc"
  unlink "~/.Xresources"
}
