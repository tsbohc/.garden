depend() {
  install dunst dunstify
}

setup() {
  link dunstrc "~/.config/dunst/dunstrc"
}

remove() {
  unlink "~/.config/dunst/dunstrc"
}
