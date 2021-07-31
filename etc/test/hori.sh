grow() {
  echo "running rake in test!"
  link $(render template) "~/.config/template"
  link link "~/.config/link"
}

weed() {
  echo "running unrake in test!"
  unlink "~/.config/link"
  unlink "~/.config/template"
}
