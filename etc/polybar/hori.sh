grow() {
  link config "~/.config/polybar/config"
}

weed() {
  unlink "~/.config/polybar/config"
}

autostart() {
  launch polybar main &
}
