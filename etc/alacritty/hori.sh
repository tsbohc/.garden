depend() {
  install alacritty
}

setup() {
  link $(render alacritty.yml) "~/.config/alacritty/alacritty.yml"
}

remove() {
  unlink "~/.config/alacritty/alacritty.yml"
}
