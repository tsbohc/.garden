grow() {
  link xinitrc "~/.xinitrc"
  link xresources "~/.Xresources"
}


weed() {
  unlink "~/.xinitrc"
  unlink "~/.Xresources"
}
