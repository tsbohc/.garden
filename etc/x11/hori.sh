setup() {
  link xinitrc ~/.xinitrc
  link xresources ~/.config/x11/.Xresources
}

remove() {
  unlink ~/.xinitrc
  unlink ~/.config/x11/.Xresources
}
