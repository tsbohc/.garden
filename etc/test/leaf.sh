rake() {
  echo "running rake in test!"
  link $(render template) "~/.config/template"
  link link "~/.config/link"
}

unrake() {
  echo "unrake in test!"
  # can use this to remove dirs, like .config/polybar
  unlink "~/.config/link"
  unlink "~/.config/template"
}
