grow() {
  link $(render alacritty.yml) "~/.config/alacritty/alacritty.yml"
}

weed() {
  unlink "~/.config/alacritty/alacritty.yml"
}
