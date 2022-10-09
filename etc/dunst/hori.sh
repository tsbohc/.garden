depend() {
  install dunst dunstify
}

add() {
  link dunstrc ~/.config/dunst/dunstrc
}

del() {
  unlink ~/.config/dunst/dunstrc
}
