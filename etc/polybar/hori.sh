depend() {
  install polybar
}

add() {
  link config ~/.config/polybar/config
}

del() {
  unlink ~/.config/polybar/config
}

autostart() {
  launch polybar main &
}
