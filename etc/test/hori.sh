setup() {
  echo "running rake in test!"
  link "$(render template)" "~/.config/template"
  link link "~/.config/link"
  link "split filename" "~/.config/split filename"
}

remove() {
  echo "running unrake in test!"
  unlink "~/.config/link"
  unlink "~/.config/template"
  unlink "~/.config/split filename"
}
