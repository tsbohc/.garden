depend() {
  install polybar
}

setup() {
  link config "~/.config/polybar/config"
}

remove() {
  unlink "~/.config/polybar/config"
}

autostart() {
  launch polybar main &
}
