depend() {
  install alacritty
}

add() {
  link $(render alacritty.yml) "~/.config/alacritty/alacritty.yml"
}

del() {
  unlink "~/.config/alacritty/alacritty.yml"
}
