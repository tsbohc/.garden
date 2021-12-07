add() {
  link xinitrc ~/.xinitrc
  link xresources ~/.config/x11/.Xresources
}

del() {
  unlink ~/.xinitrc
  unlink ~/.config/x11/.Xresources
}
