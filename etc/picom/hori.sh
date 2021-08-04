grow() {
  link picom.conf "~/.config/picom/picom.conf"
}

weed() {
  unlink "~/.config/picom/picom.conf"
}

autostart() {
  launch picom &
}
