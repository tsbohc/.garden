depend() {
  install picom
}

add() {
  link picom.conf "~/.config/picom/picom.conf"
}

del() {
  unlink "~/.config/picom/picom.conf"
}

autostart() {
  launch picom &
}
