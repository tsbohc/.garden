add() {
  echo "running setup in test!"
  link "$(render template)" "~/.config/template"
  link link "~/.config/link"
  link "split filename" "~/.config/split filename"
}

del() {
  echo "running remove in test!"
  unlink ~/.config/link
  unlink ~/.config/template
  unlink ~/.config/split\ filename
}
