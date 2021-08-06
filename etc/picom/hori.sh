setup() {
  link picom.conf "~/.config/picom/picom.conf"
}

remove() {
  unlink "~/.config/picom/picom.conf"
}

autostart() {
  launch picom &
}
