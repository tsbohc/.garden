setup() {
  link rake "~/.garden/bin/rake"
}

remove() {
  unlink "~/.garden/bin/rake"
}
